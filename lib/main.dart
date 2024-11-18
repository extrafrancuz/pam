import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CurrencyConverterScreen(),
    );
  }
}

class CurrencyConverterScreen extends StatefulWidget {
  @override
  _CurrencyConverterScreenState createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  String fromCurrency = 'MDL';
  String toCurrency = 'USD';
  double amount = 1000.0;
  double convertedAmount = 0.0;
  double exchangeRate = 17.65; // Placeholder value for MDL to USD rate

  final TextEditingController amountController = TextEditingController(text: '1000.00');

  // Function to fetch exchange rate from a public API (you can use your preferred API)
  Future<void> fetchExchangeRate() async {
    final url = Uri.parse('https://api.exchangerate-api.com/v4/latest/$fromCurrency');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        exchangeRate = data['rates'][toCurrency];
        convertCurrency();
      });
    } else {
      throw Exception('Failed to load exchange rate');
    }
  }

  // Function to convert currency
  void convertCurrency() {
    setState(() {
      convertedAmount = amount * exchangeRate;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchExchangeRate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    fromCurrency,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                amount = double.tryParse(value) ?? 0.0;
                convertCurrency();
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchExchangeRate,
              child: Text('Convert'),
            ),
            SizedBox(height: 16),
            Text(
              'Converted Amount: $convertedAmount $toCurrency',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'Exchange Rate: 1 $fromCurrency = $exchangeRate $toCurrency',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

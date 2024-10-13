import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:magadige/constants.dart';
import 'package:magadige/widgets/custom.filled.button.dart';
import 'dart:convert';

import 'package:magadige/widgets/custom.input.field.dart';

class CurrencyConvertView extends StatefulWidget {
  const CurrencyConvertView({Key? key}) : super(key: key);

  @override
  _CurrencyConvertViewState createState() => _CurrencyConvertViewState();
}

class _CurrencyConvertViewState extends State<CurrencyConvertView> {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  double? _convertedAmount;
  bool _isLoading = false;

  final String apiKey =
      'fca_live_u5S3x7T2bcGGmPubjOepaY1i2nRLh3wx2p9Ih9NE'; // Replace with your FreeCurrencyAPI key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Currency Converter',
          style: TextStyle(color: titleGrey),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomInputField(
              controller: _amountController,
              inputType: TextInputType.number,
              hint: "10",
              label: "Amount",
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDropdown('From', _fromCurrency, (value) {
                  setState(() {
                    _fromCurrency = value!;
                  });
                }),
                _buildDropdown('To', _toCurrency, (value) {
                  setState(() {
                    _toCurrency = value!;
                  });
                }),
              ],
            ),
            const SizedBox(height: 32),
            CustomButton(
              onPressed: _isLoading ? () {} : _convertCurrency,
              loading: _isLoading,
              text: "Convert",
            ),
            const SizedBox(height: 32),
            if (_convertedAmount != null)
              Text(
                'Converted Amount: ${_convertedAmount?.toStringAsFixed(2)} $_toCurrency',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }

  DropdownButton<String> _buildDropdown(
      String label, String currentValue, ValueChanged<String?> onChanged) {
    return DropdownButton<String>(
      value: currentValue,
      items: ['USD', 'EUR', 'GBP', 'JPY', 'AUD', "LKR"].map((String currency) {
        return DropdownMenuItem<String>(
          value: currency,
          child: Text(currency),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Future<void> _convertCurrency() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Enter a valid amount')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'https://api.freecurrencyapi.com/v1/latest?apikey=$apiKey&base_currency=$_fromCurrency'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rates = data['data'] as Map<String, dynamic>;
        final rate = rates[_toCurrency];
        if (rate != null) {
          setState(() {
            _convertedAmount = amount * rate;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text('Conversion rate not available for selected currency')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to fetch conversion rate')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}

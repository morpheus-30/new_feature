import 'package:flutter/material.dart';
import 'package:new_feature/api_helper.dart';

class ChipInputScreen extends StatefulWidget {
  @override
  _ChipInputScreenState createState() => _ChipInputScreenState();
}

class _ChipInputScreenState extends State<ChipInputScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final List<String> _chips = [];
  List<String> _suggestions = [];

  Future<void> _addChip(String chip) async {
    if (chip.isNotEmpty && !_chips.contains(chip)) {
      setState(() {
        _chips.add(chip);
      });
    }
    _suggestions =
        await ApiHelper.getSuggestions(_locationController.text + " " + chip);
    setState(() {});
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Suggested AI Store Type'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TextField for input
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    hintText: 'Enter your location of store',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _textController,
                  onSubmitted: _addChip,
                  decoration: InputDecoration(
                    hintText: 'Enter an item...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Chips display
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _chips
                      .map((chip) => Chip(
                            label: Text(chip),
                            onDeleted: () {
                              setState(() {
                                _chips.remove(chip);
                              });
                            },
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),

                // Suggestions list
                //wrap the suggestions as buttons and on clicked add it into the chips
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _suggestions
                      .map((suggestion) => ElevatedButton(
                            onPressed: () {
                              _addChip(suggestion);
                            },
                            child: Text(suggestion),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

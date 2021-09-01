import 'package:flutter/material.dart';

class DropDownExample extends StatefulWidget {
  DropDownExample({Key? key}) : super(key: key);

  @override
  _DropDownExampleState createState() => _DropDownExampleState();
}

class _DropDownExampleState extends State<DropDownExample> {
  int? selectedIndex;
  String? _selectedValue, dropdownValue = 'One';
  List<String>? itemName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dropdown Example')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Example One', style: TextStyle(fontWeight: FontWeight.w900)),
            DropdownButtonFormField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(6),
                focusedBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: 'Select item',
                filled: true,
                border: OutlineInputBorder(
                  // borderSide: BorderSide(width: 0, style: BorderStyle.none),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
              ),
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.black),
              isExpanded: false, 
              value: _selectedValue,
              onChanged: (value) {
                setState(() {
                  _selectedValue = value as String?;
                  selectedIndex = itemName!.indexOf(value!);
                });
              },
              items: itemName!.map((val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(val),
                );
              }).toList(),
            ),
            SizedBox(height: 18),
            Text('Example Two', style: TextStyle(fontWeight: FontWeight.w900)),
            DropdownButton<String>(
              value: _selectedValue,
              icon: Icon(Icons.arrow_downward),
              iconSize: 18,
              elevation: 10,
              hint: Text('Select item'),
              style: TextStyle(color: Colors.blue),
              underline: Container(height: 2, color: Colors.blue),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedValue = newValue!;
                });
              },
              items: itemName!.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    itemName = [
      'ItemName-1',
      'ItemName-2',
      'ItemName-3',
      'ItemName-4',
    ];
  }
}

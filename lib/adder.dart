import 'package:flutter/material.dart';
import 'bar.dart';

class AddWindow extends StatefulWidget {
  const AddWindow({super.key});

  @override
  State<AddWindow> createState() => _AddWindow();
}

class _AddWindow extends State<AddWindow> {

  int barCount= 0;
  List <Bar> bars = [];
  String error= '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container (
          width: MediaQuery.of(context).size.width*0.8,
          height: MediaQuery.of(context).size.height*0.5,
            child: Column(
              children: [
                const Text('Add a new graph', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: bars.length,
                      itemBuilder: (context, index) {
                    return  Column(
                      children: [
                        Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: "Name",
                                        ),
                                        onChanged: (text) {
                                            bars[index].name = text;
                                        },
                                      ),
                                    ),
                                    const SizedBox (width: 10),
                                    Expanded(
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: "Value",
                                        ),
                                        onChanged: (text) {
                                          try {
                                            bars[index].value = int.tryParse(text);
                                            error = '';
                                          } catch (e) {
                                            setState(() {
                                              error = 'Please enter a valid number';
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(onPressed: (){
                                      setState(() {
                                        bars.removeAt(index);
                                      });
                                    },
                                      child: const Icon(Icons.delete_outline),
                                    ),
                                  ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (barCount < 5){
                          setState(() {
                            barCount++;
                            Bar newOne  = Bar(null, null, 0);
                            bars.add(newOne);
                          });
                        }
                      },
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(width: 10),
                    const Text('Add Bar'),
                  ],
                ),
                Text(error),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, bars);
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
      ),
    );
  }
}


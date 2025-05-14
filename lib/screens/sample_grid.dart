import 'package:flutter/material.dart';

class SampleGrid extends StatefulWidget {
  const SampleGrid({super.key});

  @override
  State<SampleGrid> createState() => _SampleGridState();
}

final LinearGradient myGradient = LinearGradient(
  colors: [Colors.blue, Colors.green],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

class _SampleGridState extends State<SampleGrid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sample Grid')),
      body: Expanded(
        //background here
        child: Container(
          decoration: BoxDecoration(gradient: myGradient),
          child: Column(
            children: [
              //Top
              Container(
                height: 30,
                //margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                decoration: BoxDecoration(color: Colors.blue),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      color: Theme.of(context).colorScheme.primary,
                      child: Text('spacewalker'),
                    ),
                    Container(
                      color: const Color.fromARGB(255, 37, 127, 172),
                      child: Text('date'),
                    ),
                    Container(
                      color: const Color.fromARGB(255, 17, 55, 75),
                      child: Text('time'),
                    ),
                  ],
                ),
              ),

              //SizedBox(width: 5),

              //2nd
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //2nd row 1st col
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      color: Colors.blueGrey,
                                      child: const Center(child: Text('info')),
                                    ),
                                  ),

                                  SizedBox(height: 10),

                                  Expanded(
                                    child: Container(
                                      color: Colors.blue,
                                      child: const Center(child: Text('info')),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: 10),
                            //2nd row 2nd col
                            Expanded(
                              flex: 3,
                              child: Container(
                                color: Colors.blueGrey,
                                child: const Center(child: Text('screen')),
                              ),
                            ),
                            SizedBox(width: 10),

                            //2nd row 3rd col
                            Expanded(
                              flex: 1,
                              child: Container(
                                color: const Color.fromARGB(255, 103, 107, 28),
                                child: const Center(child: Text('dialogue')),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10),
                      //third row
                      //third row, 1st col
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                color: const Color.fromARGB(255, 158, 255, 61),
                                child: const Center(child: Text('70%')),
                              ),
                            ),
                            SizedBox(width: 10),

                            //third row, 2nd col
                            Expanded(
                              flex: 1,
                              child: Container(
                                //padding: EdgeInsets.all(100),
                                color: const Color.fromARGB(255, 29, 37, 22),
                                child: const Center(child: Text('20%')),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

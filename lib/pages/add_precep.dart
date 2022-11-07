import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';

import 'homepage.dart';

class AddPrec extends StatefulWidget {
    const AddPrec({super.key, this.user});

    final user;

    @override
    State<AddPrec> createState() => _AddPrecState(); 
}

class _AddPrecState extends State<AddPrec> {
    TextEditingController nameController = TextEditingController();
    TextEditingController doseController = TextEditingController();
    TextEditingController dateController = TextEditingController();

    Future<void> _insert() async {
        print("Connecting to mysql server...");


        final conn = await MySQLConnection.createConnection(
            host: "10.0.2.2",
            port: 3306,
            userName: "user",
            password: "1234",
            databaseName: "pillremind",
            secure: false,
        );

        await conn.connect();

        print("Connected");


        var res = await conn.execute(
            "INSERT INTO `pill` (`dose`, `time`, `user`) VALUES (:dose, :time, :user);",
            {
                "name": nameController,
                "dose": doseController,
                "time": dateController,
                "user": widget.user,
            },
        );




        await conn.close();
    }

    @override
    void initState() {
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title:const Text("เพิ่มรายการแจ้งเตินยา"),
            ),
            body: Container(
                margin: const EdgeInsets.all(8),
                child: Column(
                    children: [
                        TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                                label: Text('ชื่อยา'),
                            ),
                            onChanged: (value) => nameController.text = value,
                        ),
                        TextField(
                            controller: doseController,
                            decoration: const InputDecoration(
                                label: Text('จำนวน'),
                            ),
                            onChanged: (value) => doseController.text = value,
                        ),
                        TextField(
                            controller: dateController,
                            decoration: const InputDecoration(
                                label: Text('วันที่'),
                            ),
                            onChanged: (value) => dateController.text = value,
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () async {
                                    await _insert();


                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyHomePage(user: widget.user),
                                        ),
                                    );
                                },
                                child: const Text('เพิ่มรายการยา'),
                            ),
                        )
                    ],
                ),
            ),
        );
    }
}


import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:pillermind/pages/add_precep.dart';


class MyHomePage extends StatefulWidget {
    const MyHomePage({super.key, this.user});

    final user;

    @override
    State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


    List<Map<String, String>> displayList = [];
    Future<void> _readPill() async {
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


        var result = await conn
            .execute("SELECT * FROM pill where pill.user = `${widget.user}`;");


            List<Map<String, String>> list = [];
            for (final row in result.rows) {
                final data = {
                    'id': row.colAt(0)!,
                    'name': row.colAt(1)!,
                    'dose': row.colAt(2)!,
                    'date': row.colAt(3)!,
                    'gender': row.colAt(4)!,
                };
                list.add(data);
            }
            print('Query Success');

            setState(() {
                displayList = list;
            });


            await conn.close();
    }

    var list = [];

    @override
    void initState() {
        print('Home Page');
        _readPill();
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('ยาที่ต้องกิน'),
                actions: [
                    IconButton(
                        onPressed: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const ProfilePage(),
                            //     ),
                            // );
                        },
                        icon: const Icon(Icons.account_box))
                ],
                automaticallyImplyLeading: false,
            ),
            body: Container(
                margin: const EdgeInsets.all(8),
                child: ListView.builder(
                    itemCount: displayList.length,
                    itemBuilder: (context, index) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                        child: ListTile(
                            leading: SizedBox(
                                width: 50,
                                height: 50,
                                child: Image.asset('assets/images/pill.jpg'),
                            ),
                            title: Text(displayList[index]["name"]!),
                            subtitle: Text(
                                '${displayList[index]["dose"]!} เม็ด \n${displayList[index]["date"]!}'),
                                isThreeLine: true,
                        ),
                    ),
                ),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                    final value = Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddPrec(user: widget.user),
                        ));
                },
                tooltip: 'addPreception',
                child: const Icon( Icons.add),
            ),
        );
    }
}
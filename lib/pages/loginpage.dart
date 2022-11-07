import 'package:flutter/material.dart';
import 'package:myql_client/mysql_client.dart';
import 'package:pillermind/pages/homepage.dart';

class LoginPage extends StatefulWidget {
    const LoginPage({super.key});

    @override
    State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    List<Map<String, String>>displayList = [];

    String username = "", password "";

    Future<void> _getUserForCheck() async {
        print("Connecting ti mysql server...");


        final conn = await MySQLConnection.createConnection(
            host: "10.0.2.2",
            port 3306,
            userName: "user",
            password: "1234",
            databaseName: "pillremind",
            secure: false,
        );

        await conn.connect();

        print("Connect Success");
        var result = await conn
            .execute("select * from user where user.username = '$username'");
        List<Map<String, String>> list = [];
        for (final row in result.rows) {
            final data ={
                'id': row.colAt(0)!,
                'name': row.colAt(1)!,
                'password': row.colAt(2)!,
                'username': row.colAt(3)!,
                'telephone': row.colAt(4)!,
                'gender': row.colAt(5)!,
            };
            print(data);

            list.add(data);
        }

        setState(() {
            displayList = list;
        });

        await conn.close();
        print("Connect Close");
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Container(
                margin: const EdgeInsets.all(16),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        TextField(
                            controller: usernameController,
                            decoration: const InputDecoration(label: Text('ชื่อผู้ใช้')),
                            onChanged: (value) => username = usernameController.text,
                        ),
                        TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(label: Text('รหัสผ่าน')),
                            onChanged: (value) => password = passwordController.text,
                        ),
                        Container(
                            margin: const EdgeInsets.all(16)
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                    ElevatedButton(
                                        onPressed: () async {
                                            await _getUserForCheck();
                                            if (displayList[0]["password"] == password ) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                        MyHomePage(user: displayList[0]["id"]),
                                                    ),
                                                );  
                                            } else {
                                                print("Wrong password");
                                            }
                                        },
                                        child: const Text('เข้าสู่ระบบ'),
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                            Navigator.of(context).pushNameAndRemoveUnit(
                                                '/register', (Route<dynamic> route) => false);
                                        },
                                        child: const Text('สมัครสมาชิก'),
                                    ),
                                ],
                            ),
                        )
                    ],
                ),
            ),
        );
    }
}
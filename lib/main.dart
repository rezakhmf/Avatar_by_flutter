import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_http_get/blocs/app_events.dart';
import 'package:flutter_bloc_http_get/blocs/app_states.dart';
import 'package:flutter_bloc_http_get/repos/repositories.dart';

import 'blocs/app_blocs.dart';
import 'model/user_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home:RepositoryProvider(
        create: (context) => UserRepository(),
        child: Home(),
      ),
    );
  }
}


class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(
          RepositoryProvider.of<UserRepository>(context)
      )
        ..add(UserLoadEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('The Bloc app'),
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if(state is UserLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if(state is UserLoadedState){
              List<UserModel> userList = state.users;
              return ListView.builder(
                itemCount: userList.length,
                itemBuilder: (_, index) {
                  return Card(
                      color: Colors.lightGreen,
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        title: Text(userList[index].firstName, style: const TextStyle(
                            color: Colors.brown
                        ),),
                        subtitle: Text(userList[index].firstName, style: const TextStyle(
                          color: Colors.brown,
                        )),
                        trailing: CircleAvatar(
                          backgroundImage: NetworkImage(userList[index].avatar),
                        ),
                      )
                  );
                },
              );
            }

            if(state is UserErrorState){
              return Center(child: Text(state.error, style: TextStyle(backgroundColor: Colors.yellow),),);
            }

            return Container();
          },
        ),
      ),
    );
  }
}

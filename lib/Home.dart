import 'package:consumo_servico_avancado/Post.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as Http;
import 'dart:convert';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _urlBase = "https://jsonplaceholder.typicode.com";

  Future<List<Post>> _recuperarPostagens() async {
    Http.Response response = await Http.get(_urlBase + "/posts");
    var dadosJSON = json.decode(response.body);
    List<Post> postagens = List<Post>();

    for (var post in dadosJSON) {
      Post p = Post(post["userId"], post["id"], post["title"], post["body"]);
      postagens.add(p);
    }

    return postagens;
  }

  _post() async {
    var corpo = json.encode({
      "userId": 15,
      "id": null,
      "title": "Título",
      "body": "Corpo da postagem"
    });

    Http.Response response = await Http.post(_urlBase + "/posts",
        headers: {"Content-type": "application/json; charset=UTF8"},
        body: corpo);
  }

  _patch() {}

  _delete() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consulmo de servico avançado"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                RaisedButton(
                  onPressed: _post(),
                  child: Text("Salvar"),
                ),
                RaisedButton(
                  onPressed: _patch(),
                  child: Text("Atualizar"),
                ),
                RaisedButton(
                  onPressed: _delete(),
                  child: Text("Remover"),
                )
              ],
            ),
            Expanded(
                child: FutureBuilder<List<Post>>(
              future: _recuperarPostagens(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    break;
                  case ConnectionState.active:
                    print("conexao active");
                    break;
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                    break;
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      print("Lista:Erro ao carregar");
                    } else {
                      print("Lista: Carregou");
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, indice) {
                            List<Post> lista = snapshot.data;
                            Post p = lista[indice];

                            return ListTile(
                              title: Text(p.title),
                              subtitle: Text(p.id.toString()),
                            );
                          });
                    }
                    break;
                }
              },
            ))
          ],
        ),
      ),
    );
  }
}

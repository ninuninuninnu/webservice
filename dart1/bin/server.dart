import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'articles.dart'; //modeling of entity article

List<Article> articles = [];

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/articles', _getArticlesHandler)
  ..post('/articles', _postArticleHandler);

Future<Response> _postArticleHandler(Request request) async {
  String body = await request.readAsString();

  try {
    Article article = articleFromJson(body);
    articles.add(article);
    return Response.ok(articleToJson(article));
  } catch (e) {
    return Response(400);
  }
}

Response _getArticlesHandler(Request request) {
  return Response.ok(articlesToJson(articles));
}

Response _rootHandler(Request req) {
  return Response.ok(
      'Hello, World Im Learning code API Web Service By Dart !\n');
}

Response echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);
// For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
// Use any available host or container IP (usually 0.0.0.0).
// Configure a pipeline that logs requests.
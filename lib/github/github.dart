import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

class Github {
  Map<String, dynamic> map = {};

  File? image;

  final String personalAccessToken = '';
  final String username = 'Manvendra-Singh-SMCIC';
  final String apiUrl = 'https://api.github.com';

  Future<List<dynamic>> fetchRepositoryData() async {
    final response = await http.get(
      Uri.parse(
          'https://api.github.com/repos/Manvendra-Singh-SMCIC/Bubble-Trouble'),
      headers: {
        'Authorization': 'Bearer authtoken',
        'Accept': 'application/vnd.github.v3+json',
      },
    );

    if (response.statusCode == 200) {
      // Request successful, parse the response
      final dynamic data = json.decode(response.body);
      map = data;
      print(data);
      return [data];
    } else {
      // Request failed
      print('Failed to fetch repository data');
      return [];
    }
  }

  Future<List<dynamic>> fetchRepositoriesAll() async {
    final response = await http.get(
      Uri.parse('https://api.github.com/users/Manvendra-Singh-SMCIC/repos'),
      headers: {
        'Accept': 'application/vnd.github.v3+json',
      },
    );

    if (response.statusCode == 200) {
      // Request successful, parse the response
      print(json.decode(response.body)[0]);
      final dynamic data = json.decode(response.body)[0];
      map = data;
      print(data);
      return [data];
    } else {
      // Request failed
      throw Exception('Failed to fetch repositories');
    }
  }

  Future<http.Response> createAuthorizationHeader() async {
    return http.get(
      Uri.parse('$apiUrl/user'),
      headers: {
        'Authorization': 'Bearer $personalAccessToken',
        'Accept': 'application/vnd.github.v3+json',
      },
    );
  }

  fetchTodoList() async {
    final response = await createAuthorizationHeader();

    if (response.statusCode == 200) {
      final dynamic user = json.decode(response.body);
      final String owner = user['login'];
      final String apiUrlss = '$apiUrl/repos/$owner/$repoName/contents';

      print("hi1");
      final fileResponse = await http.get(
        Uri.parse(apiUrlss),
        headers: {
          'Authorization': 'Bearer $personalAccessToken',
          'Accept': 'application/vnd.github.v3+json',
        },
      );
      print("hi2");

      if (fileResponse.statusCode == 200) {
        print("hi3");

        log(fileResponse.body.toString());
        // log(json.decode(fileResponse.body[0].toString()));
        final dynamic files = json.decode(fileResponse.body.toString());
        print("hi4");
        print(files);
        final List<String> todoLists = [];
        log(fileResponse.body.toString());

        for (dynamic file in files) {
          if (file['type'] == 'file' && file['name'].endsWith('.md')) {
            todoLists.add(file['name']);
          }
        }

        log(todoLists.toString());

        return todoLists;
      } else {
        throw Exception('Failed to fetch Todo Lists');
      }
    } else {
      throw Exception('Failed to authenticate with GitHub');
    }
  }

  final String repoName = 'Bubble-Trouble';

  Future<http.Response> createTodoList() async {
    String todoList = "now";
    final response = await createAuthorizationHeader();

    if (response.statusCode == 200) {
      final dynamic user = json.decode(response.body);
      final String owner = user['login'];
      final String createFileUrl =
          '$apiUrl/repos/$owner/$repoName/contents/$todoList.md';

      final content = '';
      final contentBytes = utf8.encode(content);
      final contentBase64 = base64.encode(contentBytes);

      final createFileResponse = await http.put(
        Uri.parse(createFileUrl),
        headers: {
          'Authorization': 'Bearer $personalAccessToken',
          'Accept': 'application/vnd.github.v3+json',
        },
        body: json.encode({
          'message': 'Add Todo List',
          'content': contentBase64,
        }),
      );

      log("Done");

      return createFileResponse;
    } else {
      throw Exception('Failed to authenticate with GitHub');
    }
  }

  String baseUrl = 'https://api.github.com/';
  String authToken =
      'authtoken'; // Replace with your GitHub authentication token

  Future<void> createIssue(String repoOwner, String repoName, String issueTitle,
      String issueBody) async {
    String apiUrl = baseUrl + 'repos/$repoOwner/$repoName/issues';

    Map<String, String> headers = {
      'Authorization': 'token $authToken',
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> requestBody = {
      'title': issueTitle,
      'body': issueBody,
    };

    http.Response response = await http.post(Uri.parse(apiUrl),
        headers: headers, body: json.encode(requestBody));

    if (response.statusCode == 201) {
      // Issue created successfully
      print('Issue created successfully');
    } else {
      print('API request failed: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> fetchIssues(
      String repoOwner, String repoName, String authToken) async {
    String apiUrl = "https://api.github.com/repos/$repoOwner/$repoName/issues";
    String authHeaderValue = "token $authToken";

    try {
      http.Response response = await http
          .get(Uri.parse(apiUrl), headers: {'Authorization': authHeaderValue});

      if (response.statusCode == 200) {
        List<dynamic> issues = jsonDecode(response.body);
        // map = jsonDecode(response.body)[0];
        // print(response.body);
        Map<String, dynamic> mapResponse = {
          "message": "success",
          "data": response.body,
        };
        return mapResponse;
      } else {
        Map<String, dynamic> mapResponse = {
          "message": "failure",
        };
        return mapResponse;
      }
    } catch (e) {
      Map<String, dynamic> mapResponse = {
        "message": "failure",
      };
      return mapResponse;
    }
  }

  createRepository(String repoName, String authToken) async {
    String apiUrl = "https://api.github.com/user/repos";
    String authHeaderValue = "token $authToken";

    Map<String, dynamic> requestBody = {
      'name': repoName,
      'private': false,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': authHeaderValue,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        print(response.body);
        print('Succeeded to create repository');
      }
      if (response.statusCode != 201) {
        throw Exception('Failed to create repository');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<List<dynamic>> fetchCommits(
      String repoOwner, String repoName, String authToken) async {
    String apiUrl = "https://api.github.com/repos/$repoOwner/$repoName/commits";
    String authHeaderValue = "token $authToken";

    try {
      http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': authHeaderValue,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> commits = jsonDecode(response.body);
        log("HI");
        print(response.body);
        log("HIH");
        return commits;
      } else {
        throw Exception('Failed to fetch commits');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<Map<String, String>> getBranches(
      String repoOwner, String repoName, String authToken) async {
    String apiUrl = "https://api.github.com/repos/$repoOwner/$repoName";

    try {
      http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'token $authToken',
          'Accept': 'application/vnd.github.v3+json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        String baseBranch = responseBody['default_branch'];
        String headBranch = responseBody[
            'default_branch']; // Assuming the default branch is also the head branch

        print(headBranch.isEmpty ? "NO" : headBranch);
        print(1);
        print(baseBranch.isEmpty ? "NO" : baseBranch);

        return {
          'base': baseBranch,
          'head': headBranch,
        };
      } else {
        throw Exception('Failed to fetch branch information');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  mergeCode(String repoOwner, String repoName, String baseBranch,
      String headBranch, String authToken) async {
    String apiUrl = "https://api.github.com/repos/$repoOwner/$repoName/merges";
    String authHeaderValue = "token $authToken";

    try {
      Map<String, dynamic> requestBody = {
        'base': baseBranch,
        'head': headBranch,
      };

      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': authHeaderValue,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 201) {
        print("Code merge successful");
      } else {
        print('Failed to merge code');
      }
    } catch (e) {
      print('Failed to connect to the server');
    }
  }

  Future<void> addCollaborator(String repoOwner, String repoName,
      String username, String authToken) async {
    String apiUrl =
        "https://api.github.com/repos/$repoOwner/$repoName/collaborators/$username";
    String authHeaderValue = "token $authToken";

    try {
      http.Response response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': authHeaderValue,
        },
      );

      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 201) {
        print('Collaborator added successfully');
      } else {
        print('Failed to add collaborator');
        print(response.body);
      }
    } catch (e) {
      print('Failed to connect to the server');
    }
  }

  Future<dynamic> resolveIssue(String repoOwner, String repoName,
      String issueNumber, String authToken) async {
    String apiUrl =
        "https://api.github.com/repos/$repoOwner/$repoName/issues/$issueNumber";
    String authHeaderValue = "token $authToken";

    try {
      http.Response response = await http.patch(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': authHeaderValue,
          'Content-Type': 'application/json'
        },
        body: jsonEncode(
            {'state': 'closed'}), // Update the issue state to 'closed'
      );

      print(response.statusCode);
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        dynamic resolvedIssue = jsonDecode(response.body);
        print('Issue resolved successfully');
        print(response.body);
        return resolvedIssue;
      } else {
        throw Exception('Failed to resolve issue');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<bool> isPhoneNumberValid(String phoneNumber) async {
    //numverify
    final url = Uri.parse(
        'http://apilayer.net/api/validate?access_key=18ef08744a98a60d04e3f0a7190f2d09&number=$phoneNumber');
    final response = await http.get(url);

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['valid'] == true;
    } else {
      throw Exception('Failed to validate phone number');
    }
  }

  Future<bool> isEmailValid(String email) async {
    final apiKey = 'YOUR_API_KEY'; // Replace with your Mailboxlayer API key
    final url = Uri.parse(
        'http://apilayer.net/api/check?access_key=7b3cb44528fb35bf853730584aa8bda3&email=$email');
    final response = await http.get(url);

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      //will give 200 even if email is valud but does not exit
      //json field smtp-check must be true
      final result = json.decode(response.body);
      return result['format_valid'] == true && result['mx_found'] == true;
    } else {
      throw Exception('Failed to validate email');
    }
  }
}

import 'package:communication/helpers/shop_details.dart';
import 'package:communication/model/common_response.dart';
import 'package:communication/model/item.dart';
import 'package:communication/model/user.dart';
import 'package:communication/widgets/Messages.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class RequestType {
  static String get = 'GET';
  static String post = 'POST';
  static String delete = "DELETE";
}

String _baseUrl = 'http://localhost:3000';
String _version = 'v1';
String get apiUrl => '$_baseUrl/api/$_version';
String printerServer = 'http://localhost:1234';

class ApiService {
  ApiService._privateConstructor();

  static final ApiService _instance = ApiService._privateConstructor();

  static ApiService get shared => _instance;

  Map<String, String> _headers = {
    // 'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  addToken(String token) {
    _headers.addAll({'Authorization': 'Bearer $token'});
  }

  removeToken() {
    _headers.remove('Authorization');
  }

  Future<CommonResponse> _performRequest(String _url, String _type,
      {dynamic body}) async {
    bool isConnected = await Connectivity().checkConnection();
    if (isConnected) {
      return await Dio()
          .request('$apiUrl$_url',
              data: body, options: Options(method: _type, headers: _headers))
          .then((data) {
        return CommonResponse(data.data);
      }).catchError((error) {
        if (error is DioError) {
          int code = error.response.statusCode;
          print(code);
          switch (code) {
            case 404:
              Messages.simpleMessage(
                  head: "Not Found!", body: 'Please try again later');
              break;
            case 500:
              Messages.simpleMessage(
                  head: "Something went wrong!",
                  body: 'Please try again later');
              break;
            case 400:
              Messages.simpleMessage(
                  head: error.response.data['title'],
                  body: error.response.data['subtitle']);
              return CommonResponse(error.response.data);
              break;
            case 401:
              Messages.simpleMessage(
                  head: error.response.data['title'],
                  body: error.response.data['subtitle']);
              break;
            default:
              Messages.simpleMessage(
                  head: "Something went wrong!",
                  body: 'Please try again later');
          }

          return CommonResponse({
            'success': false,
            "data": null,
            "title": "Something went wrong!",
            "subtitle": "Please try again later"
          });
        } else {
          Messages.simpleMessage(
              head: "Something went wrong!", body: 'Please try again later');
          return CommonResponse({
            'success': false,
            "data": null,
            "title": "Something went wrong!",
            "subtitle": "Please try again later"
          });
        }
      });
    } else {
      Messages.noInternet();
      throw Exception('No internet');
    }
  }

  Future _printReceipt(String _url, String _type, {dynamic body}) async {
    try {
      switch (_type) {
        case "POST":
          await Dio().post('$printerServer$_url',
              data: body, options: Options(headers: _headers));
          break;
        case "GET":
          await Dio().get('$printerServer$_url',
              queryParameters: body, options: Options(headers: _headers));
          break;
        case "DELETE":
          await Dio().delete('$printerServer$_url',
              queryParameters: body, options: Options(headers: _headers));
      }
      return {'success': true};
    } catch (e) {
      return {'success': false};
    }
  }

  Future<CommonResponse> loginCall(String userName, String password) async {
    CommonResponse response = await _performRequest(
        '/lgo/user/login', RequestType.post,
        body: {'userName': userName, 'password': password});
    if (response.success) {
      print('token = ${response.data['token']}');
      addToken(response.data['token']);
    }
    return response;
  }

  Future<CommonResponse> registerCall(data) async {
    CommonResponse response =
        await _performRequest('/lg/user/create', RequestType.post, body: data);
    return response;
  }

  Future<List<User>> getAllUsersCall() async {
    CommonResponse response =
        await _performRequest('/lg/user/all', RequestType.get);
    return List<User>.from(response.data.map((x) => User.fromJson(x)));
  }

  Future<CommonResponse> updateRoleCall(data) async {
    CommonResponse response = await _performRequest(
        '/lg/user/updateIsAdmin', RequestType.post,
        body: data);
    return response;
  }

  Future<CommonResponse> updateIsDelete(dynamic data) async {
    CommonResponse response = await _performRequest(
        '/lg/user/updateIsDelete', RequestType.post,
        body: data);
    return response;
  }

  Future<CommonResponse> resetPasswordCall(dynamic data) async {
    CommonResponse response = await _performRequest(
        '/lg/user/resetPassword', RequestType.post,
        body: data);
    return response;
  }

  Future<CommonResponse> changePasswordCall(
      String oldPassword, String newPassword) async {
    CommonResponse response = await _performRequest(
        '/lg/user/changePassword', RequestType.post,
        body: {'oldPassword': oldPassword, 'newPassword': newPassword});
    return response;
  }

  Future<CommonResponse> createItemCall(dynamic data) async {
    CommonResponse response =
        await _performRequest('/lg/item/create', RequestType.post, body: data);
    return response;
  }

  Future<List<Item>> getItemsCall() async {
    CommonResponse response =
        await _performRequest('/lg/item/getAll', RequestType.get);
    return List<Item>.from(
      response.data.map(
        (item) => Item.fromJson(item),
      ),
    );
  }

  Future<List<Item>> getActiveItemsCall() async {
    CommonResponse response =
        await _performRequest('/lg/item/all_active', RequestType.get);
    return List<Item>.from(
      response.data.map(
        (item) => Item.fromJson(item),
      ),
    );
  }

  Future itemActiveInactive(int id, bool isActive) async {
    CommonResponse response = await _performRequest(
        '/lg/item/updateStatus', RequestType.post,
        body: {'isActive': isActive, 'itemId': id});
    return response;
  }

  Future<CommonResponse> updateItemCall(dynamic data) async {
    CommonResponse response =
        await _performRequest('/lg/item/update', RequestType.post, body: data);
    return response;
  }

  Future<CommonResponse> reFillItemCall(dynamic data) async {
    CommonResponse response =
        await _performRequest('/lg/item/refill', RequestType.post, body: data);
    return response;
  }

  Future<CommonResponse> createSaleCall(dynamic data) async {
    CommonResponse response =
        await _performRequest('/lg/sale/create', RequestType.post, body: data);
    return response;
  }

  Future<CommonResponse> getItemByBarcodeCall(String barcode) async {
    CommonResponse response = await _performRequest(
        '/lg/item/barcode', RequestType.get,
        body: {"barcode": barcode});
    return response;
  }

  Future<CommonResponse> getSales(DateTime date, String saleId) async {
    CommonResponse response =
        await _performRequest('/lg/sale/get', RequestType.get,
            body: date != null
                ? {"date": DateFormat('yyyy-MM-dd').format(date)}
                : saleId != null
                    ? {"id": saleId}
                    : null);
    return response;
  }

  Future testPrinter() async {
    final response = await _printReceipt('/test', RequestType.get);
    return response;
  }

  Future printBill(saleId, customer, items) async {
    final response = await _printReceipt('/print', RequestType.post, body: {
      "shopName": shopName,
      "saleId": saleId,
      "customer": customer,
      "items": items
    });
    return response;
  }
}

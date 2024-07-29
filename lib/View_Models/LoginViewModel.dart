
import 'package:get/get.dart';



import '../Models/LoginModel.dart';
import '../Repositories/LoginRepository.dart';


class LoginViewModel extends GetxController{

  var allLogin = <LoginModel>[].obs;
  // var shopNames = <String>[].obs;
  var bookerNamesByRSMDesignation = <String>[].obs;

  LoginRepository loginRepository = LoginRepository ();

  @override
  void onInit() {
    super.onInit();
    fetchAllLogin();
    // fetchShopNames();
    fetchBookerNamesByRSMDesignation();
  }
  // fetchShopNames() async {
  //   var names = await loginRepository.getShopNames();
  //   shopNames.value = names;
  // }
  fetchBookerNamesByRSMDesignation() async {
    var names = await loginRepository.getBookerNamesByRSMDesignation();
    bookerNamesByRSMDesignation.value = names;
  }
  fetchAllLogin() async {
    var login = await loginRepository.getLogin();
    allLogin.value= login;
  }


  addLogin(LoginModel loginModel){
    loginRepository.add(loginModel);
  }

  // updateShop(LoginModel loginModel){
  //   loginRepository.update(loginModel);
  //   // fetchAllShop();
  //
  // }

  deleteShop(int id){
    loginRepository .delete(id);
    fetchAllLogin();

  }

}







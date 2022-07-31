

class CartListener{

  final UpdateCartBadge updateCartBadge;

  CartListener({this.updateCartBadge});

  increaseBadge(){
    updateCartBadge.onIncreaseBadge();
  }

}

 abstract class UpdateCartBadge{
  void onIncreaseBadge();
}
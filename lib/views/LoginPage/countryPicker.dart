import 'package:flutter/material.dart';

class CountryPicker extends StatefulWidget {
  final List<dynamic> lists;
  final BorderRadius borderRadius;
  final BorderSide borderSide;
  final bool selected;
  final Color backgroundColor;
  final Color iconColor;
  final String name;
  final ValueChanged<int> onChange;
  final ValueChanged<bool> onTapped;

  const CountryPicker({
    Key key,
    this.lists,
    this.borderRadius,
    this.borderSide,
    this.selected = false,
    this.backgroundColor = const Color(0xFFF67C0B9),
    this.iconColor = Colors.black,
    this.name,
    this.onChange,
    this.onTapped
  })  : assert(lists != null),
        super(key: key);
  @override
  CountryPickerState createState() => CountryPickerState();
}

class CountryPickerState extends State<CountryPicker>
    with SingleTickerProviderStateMixin {
  GlobalKey _key;
  bool isMenuOpen = false;
  Offset buttonPosition;
  Size buttonSize;
  OverlayEntry _overlayEntry;
  BorderRadius _borderRadius;
  BorderSide _borderSide;
  AnimationController _animationController;
  Color labelGreen = Color.fromRGBO(51, 194, 174, 1);

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _borderRadius = widget.borderRadius ?? BorderRadius.circular(10);
    _borderSide = widget.borderSide ?? BorderSide(width: 1, color: Colors.grey);
    _key = LabeledGlobalKey("product_menu");
    super.initState();
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _animationController.dispose();
    super.dispose();
  }

  findButton() {
    RenderBox renderBox = _key.currentContext.findRenderObject();
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  void closeMenu() {
    if(_overlayEntry != null){
      _overlayEntry.remove();
      _overlayEntry = null;
      isMenuOpen = !isMenuOpen;
      _animationController.reverse();
    }
  }

  void openMenu() {
    closeMenu();
    findButton();
    _animationController.forward();
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context).insert(_overlayEntry);
    isMenuOpen = !isMenuOpen;
  }

  

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      decoration: BoxDecoration(
        borderRadius: _borderRadius,
      ),
      child: Stack(
        overflow: Overflow.visible,
        children: [
          GestureDetector(
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      widget.name, 
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1
                    )
                  ),
                  Center(child: Icon(Icons.arrow_drop_down, size: 25)),
                ],
              ),
            ),
            onTap: () {
              if (isMenuOpen) {
                closeMenu();
              } else {
                openMenu();
              }
            },
          ),
          Positioned(
            right:-10,
            top: 10,
            child: Visibility(
              visible: widget.selected?true:false,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.white,
                ),
                child:Icon(
                  Icons.check,
                  size: 25.0,
                  color: labelGreen,
                )
              ),
            ),
          ),
        ],
      ),
    );
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: buttonPosition.dy + buttonSize.height,
          left: buttonPosition.dx,
          // width: buttonSize.width,
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(width: 1, color: Colors.grey)
                ),
                margin: EdgeInsets.all(0),
                child: Container(
                  // height: (widget.lists.length>5)?5 * buttonSize.height-25:widget.lists.length * buttonSize.height,
                  decoration: BoxDecoration(
                    borderRadius: _borderRadius,
                  ),
                  child: (widget.lists.length>4)?MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: widget.lists.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return new GestureDetector(
                          onTap: () {
                            widget.onChange(index);
                            closeMenu();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical:10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color:Colors.grey[400])
                              )
                            ),
                            width: MediaQuery.of(context).size.width-100,
                            height: buttonSize.height,
                            child: Center(child: Text(widget.lists[index], textAlign: TextAlign.center,)),
                          ),
                        );
                      }
                    ),
                  ):Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(widget.lists.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          widget.onChange(index);
                          closeMenu();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical:10),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color:Colors.grey[400])
                            )
                          ),
                          width: MediaQuery.of(context).size.width-100,
                          // height: buttonSize.height,
                          child: Center(child: Text(widget.lists[index], textAlign: TextAlign.center,)),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
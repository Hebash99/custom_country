import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import './model/city_model.dart';
import './model/country_model.dart';
import './model/state_model.dart';

class CountryStateCityPicker extends StatefulWidget {
  TextEditingController country;
  TextEditingController state;
  TextEditingController city;

  String? initialCountry;
  String? initialState;
  String? initialCity;
  InputBorder? textFieldInputBorder;

  String? initialCountryID;

  CountryStateCityPicker({required this.country, required this.state, required this.city,this.initialCountry,this.initialState,this.initialCity, this.textFieldInputBorder});

  @override
  _CountryStateCityPickerState createState() => _CountryStateCityPickerState();
}

class _CountryStateCityPickerState extends State<CountryStateCityPicker> {
  List<CountryModel> _countryList=[];
  List<StateModel> _stateList=[];
  List<CityModel> _cityList=[];

  List<CountryModel> _countrySubList=[];
  List<StateModel> _stateSubList=[];
  List<CityModel> _citySubList=[];
  String _title='';
  String errorCountry='';
  String errorState='';

  @override
  void initState() {
    super.initState();
    _getCountry();
 // (_getIDCountry(widget.initialCountry));
    _getStateInit((_getIDCountry(widget.initialCountry) as String));
    widget.country.text=widget.initialCountry as String;
    widget.state.text=widget.initialState as String;
    widget.city.text=widget.initialCity as String;
  }

  Future<void> _getCountry()async{
    _countryList.clear();
    var jsonString = await rootBundle.loadString('packages/country_state_city_pro/assets/country.json');
    List<dynamic> body = json.decode(jsonString);
    setState(() {
      _countryList = body.map((dynamic item) => CountryModel.fromJson(item)).toList();
      _countrySubList=_countryList;
    });
  }

  Future<String?> _getIDCountry(String? countryName) async{
  _countryList.clear();
  var jsonString = await rootBundle.loadString('packages/country_state_city_pro/assets/country.json');
  List<dynamic> body = json.decode(jsonString);
  setState(() {
    _countryList = body.map((dynamic item) => CountryModel.fromJson(item)).toList();
    _countrySubList=_countryList;
  });
  for(int i=0;i<_countryList.length;i++)
    {
      if(_countryList[i].name==countryName){
        print(_countryList[i].id);
        return _countryList[i].id as String;
      }
    }
   return '';
}

  Future<void> _getState(String countryId)async{
    _stateList.clear();
    _cityList.clear();
    List<StateModel> _subStateList=[];
    var jsonString = await rootBundle.loadString('packages/country_state_city_pro/assets/state.json');
    List<dynamic> body = json.decode(jsonString);

    _subStateList = body.map((dynamic item) => StateModel.fromJson(item)).toList();
    _subStateList.forEach((element) {
      if(element.countryId==countryId){
        setState(() {
          _stateList.add(element);
        });
      }
    });
    _stateSubList=_stateList;
  }
  
  Future<void> _getStateInit(Future<String> countryId)async{
    _stateList.clear();
    _cityList.clear();
    List<StateModel> _subStateList=[];
    var jsonString = await rootBundle.loadString('packages/country_state_city_pro/assets/state.json');
    List<dynamic> body = json.decode(jsonString);

    _subStateList = body.map((dynamic item) => StateModel.fromJson(item)).toList();
    _subStateList.forEach((element) {
      if(element.countryId==countryId){
        setState(() {
          _stateList.add(element);
        });
      }
    });
    _stateSubList=_stateList;
  }
  Future<void> _getCity(String stateId)async{
    _cityList.clear();
    List<CityModel> _subCityList=[];
    var jsonString = await rootBundle.loadString('packages/country_state_city_pro/assets/city.json');
    List<dynamic> body = json.decode(jsonString);

    _subCityList = body.map((dynamic item) => CityModel.fromJson(item)).toList();
    _subCityList.forEach((element) {
      if(element.stateId==stateId){
        setState(() {
          _cityList.add(element);
        });
      }
    });
    _citySubList = _cityList;
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        ///Country TextField
         TextFormField(
          controller: widget.country,
           validator: (String? value) {
             if (value == null || value == '') {
               return 'Please enter country';
             }
             return null;
           },
          cursorColor: const Color(0xFFF16B52),
          cursorWidth: 3,
          onTap: (){
            setState(()=>_title='Country');
            _showDialog(context);
          },
           style: const TextStyle(
             decoration: TextDecoration.none,
             fontSize: 20,
           ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 20),
            fillColor: const Color(0xFFFAFAFA),
            //        contentPadding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            isDense: true,

            hintText: 'Country',
            hintStyle:
            TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFFB4B3B3),
            ),
            suffixIcon: Icon(Icons.arrow_drop_down,color: Color(0xFFF16B52),),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                    color: Color(0xFFF16B52),
                    width: 3
                )
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                    color: Color(0xFFE5E5E5),
                    width: 2
                )),

          ),
          readOnly: true,
        ),

        SizedBox(height: 8.0),

        ///State TextFormField
        TextFormField(
         controller: widget.state,
          validator: (String? value) {
            if (value == null || value == '') {
              return 'Please enter state';
            }
            return null;
          },
         onTap: (){
           setState(()=>_title='State');
           if(widget.country.text.isNotEmpty)
             _showDialog(context);
           else _showSnackBar('Select Country');
         },
          style: const TextStyle(
            decoration: TextDecoration.none,
            fontSize: 20,
          ),
         decoration: InputDecoration(
           contentPadding: EdgeInsets.only(left: 20),
           fillColor: const Color(0xFFFAFAFA),
           border: OutlineInputBorder(
             borderRadius: BorderRadius.circular(20.0),
           ),
           isDense: true,
           hintText: 'State',
           hintStyle:TextStyle(
             fontSize: 20,
             fontWeight: FontWeight.w700,
             color: Color(0xFFB4B3B3),
           ),
           suffixIcon: Icon(Icons.arrow_drop_down,color: Color(0xFFF16B52),),
           focusedBorder: OutlineInputBorder(
               borderRadius: BorderRadius.circular(20.0),
               borderSide: const BorderSide(
                   color: Color(0xFFF16B52),
                   width: 3
               )
           ),
           enabledBorder: OutlineInputBorder(
               borderRadius: BorderRadius.circular(20.0),
               borderSide: const BorderSide(
                   color: Color(0xFFE5E5E5),
                   width: 2
               )),
         ),
         readOnly: true,
       ),
        SizedBox(height: 8.0),

        ///City TextField
         TextField(
          controller: widget.city,
          onTap: (){
            setState(()=>_title='City');
            if(widget.state.text.isNotEmpty)
              _showDialog(context);
            else _showSnackBar('Select State');
          },
           style: const TextStyle(
             decoration: TextDecoration.none,
             fontSize: 20,
           ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 20),
            fillColor: const Color(0xFFFAFAFA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            isDense: true,
            hintText:'City',
            hintStyle:TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFFB4B3B3),
            ) ,
            suffixIcon: Icon(Icons.arrow_drop_down,color: Color(0xFFF16B52),),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                    color: Color(0xFFF16B52),
                    width: 3
                )
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                    color: Color(0xFFE5E5E5),
                    width: 2
                )),
          ),
          readOnly: true,
        ),

      ],
    );
  }

  void _showDialog(BuildContext context){
    TextEditingController _controller=TextEditingController();
    TextEditingController _controller2=TextEditingController();
    TextEditingController _controller3=TextEditingController();

    showGeneralDialog(
      barrierLabel: _title,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (context,__,___){
        return Material(
          color: Colors.transparent,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return Align(
                alignment: Alignment.topCenter,
                child:  Container(
                  height: MediaQuery.of(context).size.height*.7,
                  margin: EdgeInsets.only(top: 60, left: 12, right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(

                    children: [
                      SizedBox(height: 10),
                      Text(_title,style: TextStyle(color:Colors.grey.shade800,
                          fontSize: 17,fontWeight: FontWeight.w500)),
                      SizedBox(height: 10),
                      ///Text Field
                      TextField(
                        cursorColor: const Color(0xFFF16B52),
                        controller: _title=='Country'
                            ? _controller
                            : _title=='State'
                            ? _controller2
                            : _controller3,
                        onChanged: (val){
                          setState(() {
                            if(_title=='Country'){
                              _countrySubList = _countryList.where((element) =>
                                  element.name.toLowerCase().contains(_controller.text.toLowerCase())).toList();
                            }
                            else if(_title=='State'){
                              _stateSubList = _stateList.where((element) =>
                                  element.name.toLowerCase().contains(_controller2.text.toLowerCase())).toList();
                            }
                            else if(_title=='City'){
                              _citySubList = _cityList.where((element) =>
                                  element.name.toLowerCase().contains(_controller3.text.toLowerCase())).toList();
                            }
                          });
                        },
                        style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 16.0
                        ),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: const BorderSide(
                                    color: Color(0xFFF16B52),
                                    width: 3
                                )
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: const BorderSide(
                                    color: Color(0xFFE5E5E5),
                                    width: 2
                                )),
                            hintText: "Search here...",
                            contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 5),
                            isDense: true,
                            prefixIcon: Icon(Icons.search,color: Color(0xFFF16B52),)
                        ),
                      ),
                      ///Dropdown Items
                      Expanded(
                        child: Container(
                          child: ListView.builder(
                            itemCount: _title=='Country'
                                ? _countrySubList.length
                                : _title=='State'
                                ? _stateSubList.length
                                : _citySubList.length,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context,index){
                              return InkWell(
                                onTap: ()async{
                                  setState((){
                                    if(_title=="Country"){
                                      widget.country.text= _countrySubList[index].name;
                                      _getState(_countrySubList[index].id);
                                      _countrySubList=_countryList;
                                      widget.state.clear();
                                      widget.city.clear();
                                    }
                                    else if(_title=='State'){
                                      widget.state.text= _stateSubList[index].name;
                                      _getCity(_stateSubList[index].id);
                                      _stateSubList = _stateList;
                                      widget.city.clear();
                                    }
                                    else if(_title=='City'){
                                      widget.city.text= _citySubList[index].name;
                                      _citySubList = _cityList;
                                    }
                                  });
                                  _controller.clear();
                                  _controller2.clear();
                                  _controller3.clear();
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 20.0,left: 10.0,right: 10.0),
                                  child: Text(
                                      _title=='Country'
                                          ? _countrySubList[index].name
                                          : _title=='State'
                                          ? _stateSubList[index].name
                                          :_citySubList[index].name,
                                      style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontSize: 16.0
                                      )),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: (){
                          if(_title=='City' && _citySubList.isEmpty){
                            widget.city.text= _controller3.text;
                          }
                          _countrySubList=_countryList;
                          _stateSubList = _stateList;
                          _citySubList = _cityList;

                          _controller.clear();
                          _controller2.clear();
                          _controller3.clear();
                          Navigator.pop(context);
                        },
                        child: Text('Close',
                        style: TextStyle(
                          color: Color(0xFFF16B52),
                          fontSize: 16.0
                        ),),
                      )
                    ],
                  ),
                ),

                ),
              );
            },
          ),
        );
      },
      transitionBuilder: (_,anim,__,child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  void _showSnackBar(String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color(0xFFF16B52),
          content: Text(message,
              textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold)))
    );
  }
}

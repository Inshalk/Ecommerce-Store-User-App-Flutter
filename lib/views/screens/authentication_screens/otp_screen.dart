import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store/controllers/auth_controller.dart';
import 'package:mac_store/services/manage_http_response.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
 final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
 final AuthController _authController=AuthController();
  bool isLoading=false;
  List<String> otpDigits=List.filled(6, '');

  void verifyOtp()async{
    if(otpDigits.contains('')){
      showSnackBar(context, 'please fill all OTP fields');
      return;
    }
    
    setState(() {
      isLoading=true;
    });

    final otp=otpDigits.join();//Combines digits into a single otp string 

    await _authController.verifyOtp(context: context, email: widget.email, otp: otp).then((value){
      setState(() {
        isLoading=false;
      });
    });

  }

  Widget buildOtpField(int index){
    return SizedBox(width: 45,height: 55,child: TextFormField(
      validator: (value) {
        if(value!.isEmpty){
          return '';
        }
        return null;
      },
      onChanged: (value) {
        if(value.isNotEmpty && value.length==1){
          otpDigits[index]=value;

          //Automatically moves focus to next field if not last one

          if(index<5){
            FocusScope.of(context).nextFocus();
          }
        }else{
            //clare the value if input is removed
            otpDigits[index]='';
          }

      },
      onFieldSubmitted: (value) {
        //Triggered the OTP verification function
        if(index==5 && _formKey.currentState!.validate()){
          verifyOtp();
        }

      },
      
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      maxLength: 1,
      decoration: InputDecoration(
        counterText: '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey.shade200
      ),
      style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
    ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,              
              child: Column(
                children: [
                  Text(
                    'Verify your account',
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFF0d120E),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                      fontSize: 23,
                    ),
                  ),
                  const SizedBox(height: 10,),
                   Text(
                    'Enter the otp send to ${widget.email}',
                    style: GoogleFonts.lato(
                      color: const Color(0xFF0d120E),
                      fontWeight: FontWeight.bold,             
                      fontSize: 14,
                    ),),
                      
                    const SizedBox(height: 30,),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: List.generate(6, buildOtpField),),
                    
                    const SizedBox(height:30),
                    InkWell(onTap:() {
                      verifyOtp();
                    },
                    child: Container(
                      width: 319,
                      height: 50,
                      decoration: BoxDecoration(color: Color(0xFF103DE5),borderRadius: BorderRadius.circular(9)),
                      child: Center(child:isLoading?const CircularProgressIndicator(color: Colors.white,):Text('Verify',style: GoogleFonts.montserrat(
                        color: Colors.white,
                      fontWeight: FontWeight.bold,             
                      fontSize: 18,
                      ),),),
                      
                    ),
                    ),
              
                ],
                      
              ),
            ),
          ),
        ),
      ),
    );
  }
}

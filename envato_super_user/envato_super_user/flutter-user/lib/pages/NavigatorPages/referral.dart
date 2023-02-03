import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/pages/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/pages/noInternet/nointernet.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:tagyourtaxi_driver/translations/translation.dart';
import 'package:tagyourtaxi_driver/widgets/widgets.dart';
import 'package:share_plus/share_plus.dart';
import '../loadingPage/loadingpage.dart';
import 'package:http/http.dart' as http;

class ReferralPage extends StatefulWidget {
  const ReferralPage({Key? key}) : super(key: key);

  @override
  State<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  bool _isLoading = true;
  bool _showToast = false;

  @override
  void initState() {
    _getReferral();
    super.initState();
  }

//get referral code
  _getReferral() async {
    await getReferral();
    await getUrls();
    setState(() {
      _isLoading = false;
    });
  }

  var android = '';
  var ios = '';

  getUrls() async {
    android =
        'https://play.google.com/store/apps/details?id=${package.packageName}';
    var response = await http.get(Uri.parse(
        'http://itunes.apple.com/lookup?bundleId=${package.packageName}'));
    if (response.statusCode == 200) {
      ios = jsonDecode(response.body)['results'][0]['trackViewUrl'];
      // printWrapped(jsonDecode(response.body)['results'][0]['trackViewUrl']);
    }
  }

//show toast for copied
  showToast() {
    setState(() {
      _showToast = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showToast = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
      child: ValueListenableBuilder(
          valueListenable: valueNotifierHome.value,
          builder: (context, value, child) {
            return Directionality(
              textDirection: (languageDirection == 'rtl')
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(media.width * 0.05),
                    height: media.height * 1,
                    width: media.width * 1,
                    color: page,
                    child: (myReferralCode.isNotEmpty)
                        ? Column(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).padding.top),
                                    Stack(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              bottom: media.width * 0.05),
                                          width: media.width * 1,
                                          alignment: Alignment.center,
                                          child: Text(
                                            languages[choosenLanguage]
                                                ['text_enable_referal'],
                                            style: GoogleFonts.roboto(
                                                fontSize: media.width * twenty,
                                                fontWeight: FontWeight.w600,
                                                color: textColor),
                                          ),
                                        ),
                                        Positioned(
                                            child: InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Icon(
                                                    Icons.arrow_back)))
                                      ],
                                    ),
                                    SizedBox(
                                      height: media.width * 0.05,
                                    ),
                                    SizedBox(
                                      width: media.width * 0.9,
                                      height: media.height * 0.16,
                                      child: Image.asset(
                                        'assets/images/referralpage.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    SizedBox(
                                      height: media.width * 0.1,
                                    ),
                                    Text(
                                      myReferralCode[
                                          'referral_comission_string'],
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.roboto(
                                          fontSize: media.width * sixteen,
                                          color: textColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: media.width * 0.05,
                                    ),
                                    Container(
                                        width: media.width * 0.9,
                                        padding:
                                            EdgeInsets.all(media.width * 0.05),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: borderLines, width: 1.2),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              myReferralCode['refferal_code'],
                                              style: GoogleFonts.roboto(
                                                  fontSize:
                                                      media.width * sixteen,
                                                  color: textColor,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    Clipboard.setData(ClipboardData(
                                                        text: myReferralCode[
                                                            'refferal_code']));
                                                  });
                                                  showToast();
                                                },
                                                child: const Icon(Icons.copy))
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: media.width * 0.05,
                                    bottom: media.width * 0.05),
                                child: Button(
                                    onTap: () async {
                                      if (android != '' && ios != '') {
                                        await Share.share(
                                            // ignore: prefer_interpolation_to_compose_strings
                                            languages[choosenLanguage]
                                                        ['text_invitation_1']
                                                    .toString()
                                                    .replaceAll(
                                                        '55', package.appName) +
                                                ' ' +
                                                myReferralCode[
                                                    'refferal_code'] +
                                                ' ' +
                                                languages[choosenLanguage]
                                                    ['text_invitation_2'] +
                                                ' \n\nandroid\n\n' +
                                                android +
                                                '\n\niOS\n\n' +
                                                ios);
                                      } else if (android != '') {
                                        await Share.share(
                                            // ignore: prefer_interpolation_to_compose_strings
                                            languages[choosenLanguage]
                                                        ['text_invitation_1']
                                                    .toString()
                                                    .replaceAll(
                                                        '55', package.appName) +
                                                ' ' +
                                                myReferralCode[
                                                    'refferal_code'] +
                                                ' ' +
                                                languages[choosenLanguage]
                                                    ['text_invitation_2'] +
                                                ' \n\nandroid\n\n' +
                                                android);
                                      } else if (ios != '') {
                                        await Share.share(
                                            // ignore: prefer_interpolation_to_compose_strings
                                            languages[choosenLanguage]
                                                        ['text_invitation_1']
                                                    .toString()
                                                    .replaceAll(
                                                        '55', package.appName) +
                                                ' ' +
                                                myReferralCode[
                                                    'refferal_code'] +
                                                ' ' +
                                                languages[choosenLanguage]
                                                    ['text_invitation_2'] +
                                                '\n\niOS\n\n' +
                                                ios);
                                      }
                                    },
                                    text: languages[choosenLanguage]
                                        ['text_invite']),
                              )
                            ],
                          )
                        : Container(),
                  ),
                  (internet == false)
                      ? Positioned(
                          top: 0,
                          child: NoInternet(
                            onTap: () {
                              setState(() {
                                internetTrue();
                                _isLoading = true;
                                getReferral();
                              });
                            },
                          ))
                      : Container(),

                  //loader
                  (_isLoading == true)
                      ? const Positioned(top: 0, child: Loading())
                      : Container(),

                  //display toast
                  (_showToast == true)
                      ? Positioned(
                          bottom: media.height * 0.2,
                          child: Container(
                            padding: EdgeInsets.all(media.width * 0.025),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.transparent.withOpacity(0.6)),
                            child: Text(
                              languages[choosenLanguage]['text_code_copied'],
                              style: GoogleFonts.roboto(
                                  fontSize: media.width * twelve,
                                  color: Colors.white),
                            ),
                          ))
                      : Container()
                ],
              ),
            );
          }),
    );
  }
}

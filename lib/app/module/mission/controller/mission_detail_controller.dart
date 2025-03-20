import 'dart:async';
import 'dart:io';

import 'package:cashmore_app/app/module/mission/views/mission_normal_start_view.dart';
import 'package:cashmore_app/common/base_controller.dart';
import 'package:cashmore_app/common/constants.dart';
import 'package:cashmore_app/common/logger.dart';
import 'package:cashmore_app/common/model/misson_model.dart';
import 'package:cashmore_app/repository/mission_repsitory.dart';
import 'package:cashmore_app/service/app_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_handler/share_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

class MissionDetailController extends BaseController {
  final appService = Get.find<AppService>();
  MissionRepsitory missionRepsitory = MissionRepsitory();

  var isLoading = true.obs; // 로딩 상태를 관리하는 변수
  var missionTitle = ''.obs;
  var missionPoints = ''.obs;
  var missionMethod = ''.obs;
  var missionDescription = ''.obs;
  var missionInstruction = ''.obs;
  var missionQuestBrowserType = ''.obs;
  var missionHeaderHtml = ''.obs;
  var missionUrl = ''.obs;
  var missionNumber = ''.obs;
  var missionType = ''.obs;
  //var missionKeyword = ''.obs;
  var missionKeywordCopy = ''.obs;
  var missionClick = false.obs;
  //var missionAnswer1 = ''.obs;
  var sharedUrl = ''.obs;
  var missionEndUrl = ''.obs;
  var missionStartUrl = ''.obs;
  var decode = ''.obs;

  var missionKeyword = ''.obs;
  var missionAnswer1 = ''.obs;

  var fileUpload1 = ''.obs;
  var missionHint1 = ''.obs;

  var missionKeyword2 = ''.obs;
  var missionAnswer2 = ''.obs;
  var fileUpload2 = ''.obs;
  var missionHint2 = ''.obs;

  var missionKeyword3 = ''.obs;
  var missionAnswer3 = ''.obs;
  var fileUpload3 = ''.obs;
  var missionHint3 = ''.obs;

  var missionKeyword4 = ''.obs;
  var missionAnswer4 = ''.obs;
  var fileUpload4 = ''.obs;
  var missionHint4 = ''.obs;

  var missionKeyword5 = ''.obs;
  var missionAnswer5 = ''.obs;
  var fileUpload5 = ''.obs;
  var missionHint5 = ''.obs;

  var widthValue = ''.obs;

  var missionDetail = Rx<MissionModel?>(null); // 상세 데이터

  // 로딩 상태 관리 변수
  var loadingProgress = 0.0.obs;

  StreamSubscription? _intentDataStreamSubscription;

  @override
  void onInit() {
    super.onInit();
    final String questNumber = Get.arguments; // 전달된 quest_number 값 받기
    fetchMissionDetails(questNumber).then((_) {
      // 미션 정보가 로드된 후에만 _initShareListener를 호출하여 비교를 시작합니다.
      //Platform.isAndroid ? _initShareListener() : getSharedText();
      _initShareListener();
      //getSharedIOS();
    });
  }

  @override
  void onClose() {
    _intentDataStreamSubscription?.cancel(); // 스트림 해제
    super.onClose();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initShareListener() async {
     // 이전 구독 해제
    _intentDataStreamSubscription?.cancel();
    
    final handler = ShareHandlerPlatform.instance;

    // 앱이 실행될 때 공유된 초기 미디어 처리
    /*final initialMedia = await handler.getInitialSharedMedia();
    if (initialMedia != null) {
      _handleSharedMedia(initialMedia);
    }*/

    // 이후 공유된 미디어 스트림 구독
    handler.sharedMediaStream.listen((SharedMedia media) {
      _handleSharedMedia(media);
    }, onError: (error) {
      print("Error receiving shared media: $error");
    });
  }

  /// 공유된 미디어(텍스트)를 처리하는 함수
  void _handleSharedMedia(SharedMedia media) {
    // 공유된 미디어가 텍스트로 전달되었다고 가정 (ex. URL)
    // (패키지에 따라 media.text 또는 media.data 등으로 접근할 수 있습니다)
    final String? sharedText = media.content;
    //print("sharedText: ${sharedText}");
    if (sharedText != null && sharedText.isNotEmpty) {
      // URL 디코딩 후 저장
      final decodedUrl = Uri.decodeComponent(sharedText);
      sharedUrl.value = decodedUrl;
      print("Received shared URL: $decodedUrl");
      print("missionEndUrl: ${missionEndUrl.value}");

      // 미션 타입이 "3"인 경우에만 처리
      if (missionType == "3") {
        try {
          // 미션 URL과 공유 URL의 마지막 슬래시 제거 후 파싱
          final missionUri = Uri.parse(missionEndUrl.value.replaceAll(RegExp(r'/$'), ''));
          final sharedUri = Uri.parse(decodedUrl.replaceAll(RegExp(r'/$'), ''));
print("missionUri: $missionUri");
print("sharedUri: $sharedUri");
          // host와 path 비교 (프로토콜 무시)
          if (missionUri.host == sharedUri.host && missionUri.path == sharedUri.path) {
            // 미션 성공 처리 함수 호출
            missionEnd(missionNumber.value);
            //print("미션 성공 ");
          } else {
            //Get.snackbar("알림", "URL이 맞지 않습니다. 다시 시도 해주세요.");
          }
        } catch (e) {
          print("Error parsing URLs: $e");
          //Get.snackbar("알림", "URL을 올바르게 인식하지 못했습니다. 다시 시도해주세요.");
        }
      }
    } else {
      print("공유된 미디어에 텍스트가 포함되어 있지 않습니다.");
    }
  }


  // API에서 데이터 가져오기
  Future<void> fetchMissionDetails(String questNumber) async {
    try {
      isLoading.value = true; // 데이터 로드 시작

      MissionModel response = await missionRepsitory.missionDetail(AppService.to.userId!, questNumber);
      missionDetail.value = response;

      String pointStr = response.quest_use_price.toString() + " 포인트 받기";
      if (response.boost_price.toString() != "0") {
        pointStr = pointStr + " +" + response.boost_price.toString();
      }

      missionPoints.value = pointStr;

      missionDescription.value = response.quest_description!;
      missionInstruction.value = response.answer1!;
      missionQuestBrowserType.value = response.quest_browser_type!;
      missionHeaderHtml.value = response.quest_header_html!;
      missionUrl.value = response.quest_url!;
      missionNumber.value = questNumber;
      missionType.value = response.quest_type;

      missionKeyword.value = response.keyword1!;
      missionAnswer1.value = response.answer1!;

      missionEndUrl.value = response.quest_end_url!;
      missionStartUrl.value = response.quest_start_url!;
      decode.value = response.decode!;
      missionKeywordCopy.value = response.quest_keyword_copy!;

      fileUpload1.value = response.file_upload1!;
      missionHint1.value = response.question_hint1!;

      missionHint2.value = response.question_hint2!;
      missionAnswer2.value = response.answer2!;
      missionKeyword2.value = response.keyword2!;
      fileUpload2.value = response.file_upload2!;

      missionHint3.value = response.question_hint3!;
      missionAnswer3.value = response.answer3!;
      missionKeyword3.value = response.keyword3!;
      fileUpload3.value = response.file_upload3!;

      missionHint4.value = response.question_hint4!;
      missionAnswer4.value = response.answer4!;
      missionKeyword4.value = response.keyword4!;
      fileUpload4.value = response.file_upload4!;

      missionHint5.value = response.question_hint5!;
      missionAnswer5.value = response.answer5!;
      missionKeyword5.value = response.keyword5!;
      fileUpload5.value = response.file_upload5!;

      RegExp regExp = RegExp(r'<img[^>]*\bwidth\s*:\s*([\d\.]+)(px|%)?[^>]*>', caseSensitive: false);

      Match? match = regExp.firstMatch(missionHeaderHtml.value);

      if (match != null) {
        String widthValuea = match.group(1) ?? 'unknown';
        String widthUnita = match.group(2) ?? 'unknown';
        widthValue.value = widthValuea;
        print('이미지 width: $widthValue $widthUnita');
      } else {
        print('width 속성이 지정되지 않음');
      }
    } catch (e) {
      print("Error fetching mission details: $e");
    } finally {
      isLoading.value = false; // 데이터 로드 완료
    }
  }

  // URL 열기 메서드
  Future<void> openUrlWithBrowser(String url, String type) async {
    missionClick.value = true;
    print("url====>$url");
    print("type====>$type");

    if (url.isEmpty) {
      Get.snackbar(
        '오류',
        '미션을 완료할 수 없습니다.\nURL이 없습니다.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Uri uri = Uri.parse(url);
    print("uri====>${uri.toString()}");

    bool canLaunchApp;
    Uri storeUri;

    // 임시로 '파이어폭스'와 '웨일'을 '크롬'으로 처리
    if (type == '파이어폭스' || type == '웨일') {
      type = "크롬";
    }

    switch (type) {
      case '기본 브라우저':
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;

      case '파이어폭스':
        canLaunchApp = await canLaunchUrl(Uri.parse("firefox://"));
        storeUri = Uri.parse(Theme.of(Get.context!).platform == TargetPlatform.android
            ? "https://play.google.com/store/apps/details?id=org.mozilla.firefox"
            : "https://apps.apple.com/us/app/firefox-web-browser/id989804926");
        uri = Uri.parse("firefox://open-url?url=${Uri.encodeFull(url)}");
        break;

      case '네이버':
        canLaunchApp = await canLaunchUrl(Uri.parse("naversearchapp://"));
        storeUri = Uri.parse(
            Theme.of(Get.context!).platform == TargetPlatform.android ? "https://play.google.com/store/apps/details?id=com.nhn.android.search" : "https://apps.apple.com/us/app/naver/id393499958");
        uri = Uri.parse("naversearchapp://inappbrowser?url=${Uri.encodeFull(url)}&target=new&version=6");
        break;

      case '크롬':
        if (Theme.of(Get.context!).platform == TargetPlatform.android) {
          canLaunchApp = await canLaunchUrl(Uri.parse("googlechrome://"));
          storeUri = Uri.parse("https://play.google.com/store/apps/details?id=com.android.chrome");
          //uri = Uri.parse(url.replaceFirst('https://', 'googlechrome://'));
          //uri = Uri.parse(getChromeIntentUrl(url.replaceFirst('https://', '')));

          final String encodedUrl = Uri.encodeComponent(url);
          uri = Uri.parse('googlechrome://navigate?url=$url');
        } else {
          canLaunchApp = await canLaunchUrl(Uri.parse("googlechrome-x-callback://"));
          storeUri = Uri.parse("https://apps.apple.com/us/app/google-chrome/id535886823");
          uri = Uri.parse(url.replaceFirst('https://', 'googlechrome-x-callback://'));
        }
        break;

      case '웨일':
        canLaunchApp = await canLaunchUrl(Uri.parse("naver-whale://"));
        storeUri = Uri.parse(Theme.of(Get.context!).platform == TargetPlatform.android
            ? "https://play.google.com/store/apps/details?id=com.naver.whale"
            : "https://apps.apple.com/us/app/naver-whale-browser/id1453021273");
        uri = Uri.parse(url.replaceFirst('https://', 'naver-whale://'));
        break;

      default:
        throw Exception('지원되지 않는 브라우저 타입입니다.');
    }

    //print("canLaunchApp=====>>>>${canLaunchApp}");
    /*if (canLaunchApp) {
      print("uri=====>>>>${uri.toString()}");
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("Launching App Store: ${storeUri.toString()}");
      await launchUrl(storeUri, mode: LaunchMode.externalApplication);
    }*/
    try {
      print("uri=====>>>>${uri.toString()}");
      await launchUrl(uri);
    } catch (e) {
      print("Chrome 앱이 열리지 않음, 앱스토어로 이동합니다.");
      await launchUrl(storeUri, mode: LaunchMode.externalApplication);
    }
  }

  Future<bool> isChromeInstalled() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName.contains("chrome");
  }

  String getChromeIntentUrl(String url) {
    return "intent://$url#Intent;scheme=https;package=com.android.chrome;end;";
  }

  void startLoadingAnimation() {
    loadingProgress.value = 0.0;
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (loadingProgress.value >= 1.0) {
        loadingProgress.value = 1.0;
        timer.cancel();
      } else {
        loadingProgress.value += 0.01;
      }
    });
  }

  Future<void> missionStart(String url, String questNumber, String questType, String questBrowserType) async {
    String? deviceId = await appService.getDeviceUniqueId();
    var user = await AppService().getUser();

    logger.i("deviceId=====> " + deviceId.toString());

    Map<String, dynamic> requestBody = {
      "user_id": user.user_id,
      "user_name": user.user_name,
      "quest_number": questNumber,
      "member_adid": deviceId,
    };

    try {
      await missionRepsitory.missionStart(requestBody).then((response) async {
        var urlHttps = url;
        if (!url.startsWith('https://') && !url.startsWith('http://')) {
          urlHttps = 'https://$url';
        }

        //일반
        if (questType == "1") {
          // 성공 시, 다음 화면으로 이동
          var result = await Get.to(() => MissionNormalStartView(url: url));
          if (result == true) {
            // NewScreen에서 true를 반환했을 때 실행할 로직
            Get.back(closeOverlays: true, result: true);
          }
        }
        //정답/ 답변
        else if (questType == "2" || questType == "3") {
          openUrlWithBrowser(urlHttps, questBrowserType);
        }
        // 스페셜
        else if (questType == "4") {
          openUrlWithBrowser(urlHttps, questBrowserType);
        }
        //캡처
        else {}
      });
    } catch (e) {
      // 실패 시, 오류 알림
      Get.snackbar(
        '오류',
        '퀘스트를 시작할 수 없습니다.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> missionEnd(String questNumber) async {
    Map<String, dynamic> requestBody = {
      "user_id": AppService.to.userId!,
      "quest_number": questNumber,
      "quest_type": missionType.value,
    };

    try {
      // 미션 완료 API 호출
      await missionRepsitory.missionEnd(requestBody).then((response) async {
        // 진동 발생
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(duration: 500); // 500ms 동안 진동
        }

        // 성공 시 알림 표시
        Get.snackbar(
          '알림',
          '퀘스트가 완료 되었습니다.',
          snackPosition: SnackPosition.TOP,
          //backgroundColor: Colors.green,
          colorText: Colors.black,
        );

        // 화면 닫기
        await Future.delayed(const Duration(milliseconds: 1500), () {
          Get.back(closeOverlays: true, result: true);
        });
      });
    } catch (e) {
      // 실패 시 알림과 진동
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(pattern: [0, 500, 200, 500]); // 진동 패턴
      }

      Get.snackbar(
        '오류',
        '퀘스트를 완료할 수 없습니다.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      // 화면 닫기
      Get.back();
    }
  }

  Widget buildNull(String url) {
    return Container(
      child: Text('준비중 입니다..'),
    );
  }

  Widget buildWebViewIf(String code, String url, BuildContext context) {
    var result = decode.split('|')[0];

    switch (result) {
      case NAVER_PALCE_ARAR:
        return buildWebViewNotice(url);
      case NAVER_PALCE_SAVE:
        return buildWebViewSave(url);
      case NAVER_PALCE_KEEP:
        return buildWebViewKeep(url);
      case NAVER_PALCE_BLOG:
        return buildWebViewBlog(url);
      case KAKAO_GIFT_LIKE:
        return buildWebViewKakaoGiftSelect(url);
      case KAKAO_GIFT_REVIEW:
        return buildNull(url);
      case RANK_UP_QUEST:
        return buildNull(url);
      case MUSINSA_PROD_LIKE:
        return Platform.isAndroid ? buildWebViewMusinsaLikeAnd(url) : buildWebViewMusinsaLike(url);
      case MUSINSA_BRAND_LIKE:
        return Platform.isAndroid ? buildWebViewMusinsaBrandLikeAnd(url) : buildWebViewMusinsaBrandLike(url);
      case NAVER_SMART_PROD_LIKE:
        return buildWebViewNaverBrandLike(url);
      case NAVER_SMART_ARAR:
        return buildWebViewNaverBrandAram(url);
      case OLIVE_PROD_LIKE:
        return Platform.isAndroid ? buildWebViewOliveYoungWishAnd(url) : buildWebViewOliveYoungWish(url);
      case OLIVE_BRAND_LIKE:
        return Platform.isAndroid ? buildWebViewOliveYoungBrandLikeAnd(url) : buildWebViewOliveYoungBrandLike(url);
      case NOW_PROD_LIKE:
        //return Platform.isAndroid ? buildWebViewOHouseScrapAnd(url) : buildWebViewOHouseScrap(url);
        return buildWebViewOHouseScrapAnd(url);
      default:
        return buildNull(url);
    }

    //return buildWebViewKakaoGiftSelect(url);
    //return buildWebViewKakaoGiftWithLogin(url,"https://accounts.kakao.com/login/?continue=https%3A%2F%2Fkauth.kakao.com&talk_login=&login_type=simple#login" );
  }

  // 웹뷰 저장하기
  Widget buildWebViewSave(String url) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      onLoadStop: (webController, webUrl) async {
        await webController.evaluateJavascript(source: '''
          (function() {
            function applyRedBorder() {
              const saveButtons = document.querySelectorAll(".D_Xqt");
              if (saveButtons.length > 1) {
                const secondSaveButton = saveButtons[1];
                secondSaveButton.style.border = "2px solid red";
                secondSaveButton.style.padding = "4px";
              }
              const actionButton = document.querySelector(".swt-save-btn");
              if (actionButton) {
                actionButton.onclick = function() {
                  window.flutter_inappwebview.callHandler('onSaveButtonClicked');
                };
              }
            }
            const observer = new MutationObserver((mutations) => {
              mutations.forEach((mutation) => {
                applyRedBorder();
              });
            });
            observer.observe(document.body, { childList: true, subtree: true });
            applyRedBorder();
          })();
        ''');
        loadingProgress.value = 1.0;
      },
      onWebViewCreated: (webController) {
        webController.addJavaScriptHandler(
          handlerName: 'onSaveButtonClicked',
          callback: (args) {
            missionEnd(missionNumber.value);
          },
        );
      },
    );
  }

  // 웹뷰 알림받기
  Widget buildWebViewNotice(String url) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      onLoadStop: (webController, webUrl) async {
        await webController.evaluateJavascript(source: '''
          (function() {
            function applyRedBorder() {
              // Target the specific button with "알림받기"
              const alertButton = document.querySelector(".QKxqx"); // Assuming this is the class for the "알림받기" button
              if (alertButton) {
                alertButton.style.border = "2px solid red"; // Add red border
                alertButton.style.padding = "4px"; // Add padding for visibility
                
                const actionButton = document.querySelector(".ZKkmn .bsf0k .Mb1bO.K7Fw3");
                if (actionButton) {
                  actionButton.onclick = function() {
                    window.flutter_inappwebview.callHandler('onNotifyButtonClicked');
                  };
                }
              }
            }

            // MutationObserver to detect DOM changes
            const observer = new MutationObserver((mutations) => {
              mutations.forEach((mutation) => {
                applyRedBorder();
              });
            });

            // Observe changes in the DOM to apply styles dynamically
            observer.observe(document.body, { childList: true, subtree: true });

            // Initial application of red border
            applyRedBorder();
          })();
        ''');
        loadingProgress.value = 1.0;
      },
      onWebViewCreated: (webController) {
        webController.addJavaScriptHandler(
          handlerName: 'onNotifyButtonClicked',
          callback: (args) {
            missionEnd(missionNumber.value);
            //Get.snackbar('알림', '확인 버튼이 눌렸습니다.');
          },
        );
      },
    );
  }

  // 웹뷰 Keep
  Widget buildWebViewKeep(String url) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      onLoadStop: (webController, webUrl) async {
        await webController.evaluateJavascript(source: '''
          (function() {
            function applyRedBorderToShareButton() {
              // Target the "공유" button
              const shareButton = document.querySelectorAll(".D_Xqt"); // Assuming this is the class for the "공유" button
              if (shareButton.length > 1) {
                const secondShareButton = shareButton[3];
                secondShareButton.style.border = "2px solid red"; // Add red border to "공유" button
                secondShareButton.style.padding = "4px"; // Add padding for visibility
                
                // Add onclick event to the "공유" button to apply red border to the keep button
                secondShareButton.onclick = function() {
                  applyRedBorderToKeepButton();
                };
              }
            }

            function applyRedBorderToKeepButton() {
              // Target the keep button after "공유" is clicked
              const keepButton = document.querySelector(".spim_be.link_keep._spi_keep");

              if (keepButton) {
                keepButton.style.border = "2px solid red"; // Add red border to keep button
                keepButton.style.padding = "4px"; // Add padding for visibility

                // Add onclick event to the keep button to call Flutter handler
                keepButton.onclick = function() {
                  window.flutter_inappwebview.callHandler('onKeepButtonClicked');
                };
              }
            }

            // MutationObserver to detect DOM changes
            const observer = new MutationObserver((mutations) => {
              mutations.forEach((mutation) => {
                applyRedBorderToShareButton();
                applyRedBorderToKeepButton();
              });
            });

            // Observe changes in the DOM to apply styles dynamically
            observer.observe(document.body, { childList: true, subtree: true });

            // Initial application of red border
            applyRedBorderToShareButton();
            applyRedBorderToKeepButton();
          })();
        ''');
        loadingProgress.value = 1.0;
      },
      onWebViewCreated: (webController) {
        webController.addJavaScriptHandler(
          handlerName: 'onKeepButtonClicked',
          callback: (args) {
            // Show snackbar when keep button is clicked
            missionEnd(missionNumber.value);
          },
        );
      },
    );
  }

  // 웹뷰 블로그
  Widget buildWebViewBlog(String url) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      onLoadStop: (webController, webUrl) async {
        await webController.evaluateJavascript(source: '''
          (function() {
            function applyRedBorderToShareButton() {
              // "공유" 버튼을 찾습니다
              const shareButton = document.querySelectorAll(".D_Xqt"); // 필요에 따라 이 선택자를 조정하세요
              if (shareButton.length > 1) {
                const secondShareButton = shareButton[3];
                secondShareButton.style.border = "2px solid red"; // "공유" 버튼에 빨간 테두리 추가
                secondShareButton.style.padding = "4px"; // 가시성을 위해 패딩 추가
                
                // "공유" 버튼에 클릭 이벤트 추가하여 "블로그" 버튼에 테두리 추가
                secondShareButton.onclick = function() {
                  setTimeout(applyRedBorderToBlogButton, 500); // 레이어가 나타날 때까지 대기
                };
              }
            }

            function applyRedBorderToBlogButton() {
              // 새로운 레이어에서 "블로그" 버튼을 찾습니다
              const blogButton = document.querySelector(".spim_be.link_blog._spi_blog"); // 필요에 따라 선택자 조정
              if (blogButton) {
                blogButton.style.border = "2px solid red"; // "블로그" 버튼에 빨간 테두리 추가
                blogButton.style.padding = "4px"; // 가시성을 위해 패딩 추가

                // "블로그" 버튼에 클릭 이벤트 추가하여 다음 단계로 이동
                blogButton.onclick = function() {
                  setTimeout(observeConfirmButton, 1000); // 다음 페이지가 로드될 때까지 대기
                };
              }
            }

            function observeConfirmButton() {
              // "확인" 버튼이 나타날 때까지 DOM 변화를 감지합니다
              const observer = new MutationObserver((mutations) => {
                mutations.forEach((mutation) => {
                  applyRedBorderToConfirmButton();
                });
              });

              // DOM 변화를 감시하여 "확인" 버튼을 동적으로 찾습니다
              observer.observe(document.body, { childList: true, subtree: true });
            }

            function applyRedBorderToConfirmButton() {
              // 다음 페이지에서 "확인" 버튼을 찾습니다
              const confirmButton = document.querySelector(".head.btn_area.btn_ok"); // "확인" 버튼에 대한 실제 선택자로 변경
              if (confirmButton) {
                confirmButton.style.border = "2px solid red"; // "확인" 버튼에 빨간 테두리 추가
                confirmButton.style.padding = "4px"; // 가시성을 위해 패딩 추가

                // "확인" 버튼에 클릭 이벤트 추가하여 스낵바 표시
                confirmButton.onclick = function() {
                  window.flutter_inappwebview.callHandler('onConfirmButtonClicked');
                };
              }
            }

            // DOM 변화를 감지하는 MutationObserver 설정
            const observer = new MutationObserver((mutations) => {
              mutations.forEach((mutation) => {
                applyRedBorderToShareButton();
              });
            });

            // DOM 변화를 감시하여 동적으로 스타일 적용
            observer.observe(document.body, { childList: true, subtree: true });

            // 초기 상태에서 "공유" 버튼에 테두리 적용
            applyRedBorderToShareButton();
          })();
        ''');
        loadingProgress.value = 1.0;
      },
      onWebViewCreated: (webController) {
        webController.addJavaScriptHandler(
          handlerName: 'onConfirmButtonClicked',
          callback: (args) {
            // "확인" 버튼을 클릭할 때 스낵바 표시
            //Get.snackbar('알림', '확인 버튼이 눌렸습니다.');
            missionEnd(missionNumber.value);
          },
        );
      },
    );
  }

  // 웹뷰 카카오선물하기 찜
  Widget buildWebViewKakaoGiftSelect(String url) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      onLoadStop: (webController, webUrl) async {
        // MutationObserver로 로그인 후 "위시리스트 추가하기" 버튼에 빨간 테두리 적용
        await webController.evaluateJavascript(source: '''
        (function() {
          function applyRedBorderToWishlistButton() {
            // "위시리스트 추가하기" 버튼 찾기
            var wishButton = document.querySelector(".item_btn.item_wish .btn_g");
            if (wishButton) {
              wishButton.style.border = "2px solid red"; // 빨간 테두리 추가
              wishButton.style.padding = "4px"; // 패딩 추가
            }
          }

          // MutationObserver를 사용하여 DOM 변화를 감지하고 "위시리스트 추가하기" 버튼에 스타일을 적용
          const observer = new MutationObserver((mutations) => {
            mutations.forEach((mutation) => {
              applyRedBorderToWishlistButton();
            });
          });

          // body의 변화 감지 설정
          observer.observe(document.body, { childList: true, subtree: true });

          // 초기 스타일 적용 (로그인 후에도 적용되도록)
          applyRedBorderToWishlistButton();
        })();
      ''');
        loadingProgress.value = 1.0;
      },
      onWebViewCreated: (webController) {
        webController.addJavaScriptHandler(
          handlerName: 'onSaveButtonClicked',
          callback: (args) {
            //missionEnd(missionNumber.value);
          },
        );
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        final uri = navigationAction.request.url;

        if (!navigationAction.isForMainFrame) {
          await controller.stopLoading();
        }

        if (uri != null) {
          // Intent URL 처리
          if (uri.scheme == 'intent') {
            final intentUri = Uri.tryParse(uri.toString());
            if (intentUri != null) {
              // browser_fallback_url 추출
              final fallbackUrl = intentUri.queryParameters['S.browser_fallback_url'];
              if (fallbackUrl != null) {
                // Fallback URL 로드
                await controller.loadUrl(
                  urlRequest: URLRequest(url: WebUri(fallbackUrl)),
                );
              } else {
                // Fallback URL이 없으면 Intent를 외부 앱으로 전달
                try {
                  await launchUrl(
                    Uri.parse(uri.toString()),
                    mode: LaunchMode.externalApplication,
                  );
                } catch (e) {
                  debugPrint("Unable to handle intent URL: $e");
                  // 사용자에게 앱 설치를 안내
                  //_showAlertDialog(context, "앱 실행 불가", "이 기능을 사용하려면 카카오톡 앱이 필요합니다.");
                  debugPrint("앱 실행 불가: 이 기능을 사용하려면 카카오톡 앱이 필요합니다.");
                }
              }
            }
            return NavigationActionPolicy.CANCEL; // WebView에서 로드 중단
          }

          // 카카오톡 스킴 처리
          if (uri.scheme == 'kakaotalk') {
            try {
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                debugPrint("Unable to open KakaoTalk app.");
                //_showAlertDialog(context, "앱 실행 불가", "카카오톡 앱이 설치되어 있지 않습니다.");
                debugPrint("앱 실행 불가: 카카오톡 앱이 설치되어 있지 않습니다.");
              }
            } catch (e) {
              debugPrint("카카오톡 앱 실행 중 오류 발생: $e");
            }
            return NavigationActionPolicy.CANCEL; // WebView에서 로드 중단
          }
        }

        return NavigationActionPolicy.ALLOW; // WebView에서 URL 로드 허용
      },
    );
  }

  Widget buildWebViewMusinsaLike(String url) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      onLoadStop: (webController, webUrl) async {
        await webController.evaluateJavascript(source: '''
        (function() {
          if (window.isLikeScriptInitialized) {
            return; // 스크립트가 이미 초기화되었으면 다시 실행하지 않음
          }
          window.isLikeScriptInitialized = true; // 스크립트가 처음 실행됨을 표시

          function applyRedBorderAndClickEvent() {
            var likeButton = document.querySelector('.gtm-add-to-wishlist');
            if (likeButton && !likeButton.hasAttribute('data-event-added')) {
              likeButton.style.border = "2px solid red";
              likeButton.style.padding = "4px";
              likeButton.setAttribute('data-event-added', 'true');

              likeButton.addEventListener('click', function(event) {
                setTimeout(function() {
                  var isLiked = likeButton.classList.contains('gtm-remove-from-wishlist');
                  window.flutter_inappwebview.callHandler('onLikeStatusChecked', isLiked);
                }, 1000);
              });
            }
          }

          // MutationObserver로 버튼 상태 변화를 감지하여 이벤트 재등록
          var observer = new MutationObserver(function(mutations) {
            mutations.forEach(function(mutation) {
              if (mutation.type === 'attributes' && mutation.target.classList.contains('gtm-add-to-wishlist')) {
                applyRedBorderAndClickEvent();
              }
            });
          });

          // 좋아요 버튼이 존재할 때 MutationObserver를 통해 상태 감시 시작
          var likeButton = document.querySelector('.gtm-add-to-wishlist');
          if (likeButton) {
            applyRedBorderAndClickEvent();
            observer.observe(likeButton, { attributes: true });
          }

          // 주기적으로 좋아요 버튼이 생기는지 확인
          var checkButtonInterval = setInterval(function() {
            var likeButton = document.querySelector('.gtm-add-to-wishlist');
            if (likeButton) {
              applyRedBorderAndClickEvent();
              observer.observe(likeButton, { attributes: true });
              clearInterval(checkButtonInterval); // 확인 후 주기 중지
            }
          }, 1000); 

          // 주기적으로 gtm-remove-from-wishlist 버튼이 생기는지 확인
          window.checkButtonInterval2 = setInterval(function() {
            var likeButton2 = document.querySelector('.gtm-remove-from-wishlist');
            if (likeButton2) {
              clearInterval(checkButtonInterval); // 확인 후 주기 중지
              clearInterval(window.checkButtonInterval2); // 확인 후 주기 중지
              window.flutter_inappwebview.callHandler('onLikeStatusChecked', true);
            }
          }, 1000);
        })();
      ''');

        loadingProgress.value = 1.0;
      },
      onWebViewCreated: (webController) {
        webController.addJavaScriptHandler(
          handlerName: 'onLikeStatusChecked',
          callback: (args) async {
            bool isLiked = args[0];
            if (isLiked) {
              //Get.snackbar("알림", "좋아요가 설정되었습니다.");
              missionEnd(missionNumber.value);
            }
          },
        );
      },
    );
  }

  Widget buildWebViewMusinsaLikeAnd(String url) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        domStorageEnabled: true,
        userAgent: "Mozilla/5.0 (Linux; Android 10; SM-G960N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.91 Mobile Safari/537.36",
      ),
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        var uri = navigationAction.request.url;

        if (uri != null && uri.scheme == "intent") {
          try {
            final fallbackUrl = Uri.decodeFull(uri.toString()).split("S.browser_fallback_url=").last.split(";end").first;

            // 내부 WebView에서 로드
            await controller.loadUrl(urlRequest: URLRequest(url: WebUri(fallbackUrl)));
          } catch (e) {
            print("Fallback URL 처리 실패: $e");
          }
          return NavigationActionPolicy.CANCEL; // 원래 로드 취소
        }

        return NavigationActionPolicy.ALLOW; // WebView에서 계속 로드
      },
      onLoadStop: (webController, webUrl) async {
        await webController.evaluateJavascript(source: '''
        (function() {
          if (window.isLikeScriptInitialized) {
            return; // 스크립트가 이미 초기화되었으면 다시 실행하지 않음
          }
          window.isLikeScriptInitialized = true; // 스크립트가 처음 실행됨을 표시

          function applyRedBorderAndClickEvent() {
            var likeButton = document.querySelector('.gtm-add-to-wishlist');
            if (likeButton && !likeButton.hasAttribute('data-event-added')) {
              likeButton.style.border = "2px solid red";
              likeButton.style.padding = "4px";
              likeButton.setAttribute('data-event-added', 'true');

              likeButton.addEventListener('click', function(event) {
                setTimeout(function() {
                  var isLiked = likeButton.classList.contains('gtm-remove-from-wishlist');
                  window.flutter_inappwebview.callHandler('onLikeStatusChecked', isLiked);
                }, 1000);
              });
            }
          }

          // MutationObserver로 버튼 상태 변화를 감지하여 이벤트 재등록
          var observer = new MutationObserver(function(mutations) {
            mutations.forEach(function(mutation) {
              if (mutation.type === 'attributes' && mutation.target.classList.contains('gtm-add-to-wishlist')) {
                applyRedBorderAndClickEvent();
              }
            });
          });

          // 좋아요 버튼이 존재할 때 MutationObserver를 통해 상태 감시 시작
          var likeButton = document.querySelector('.gtm-add-to-wishlist');
          if (likeButton) {
            applyRedBorderAndClickEvent();
            observer.observe(likeButton, { attributes: true });
          }

          // 주기적으로 좋아요 버튼이 생기는지 확인
          var checkButtonInterval = setInterval(function() {
            var likeButton = document.querySelector('.gtm-add-to-wishlist');
            if (likeButton) {
              applyRedBorderAndClickEvent();
              observer.observe(likeButton, { attributes: true });
              clearInterval(checkButtonInterval); // 확인 후 주기 중지
            }
          }, 1000); 

          // 주기적으로 gtm-remove-from-wishlist 버튼이 생기는지 확인
          window.checkButtonInterval2 = setInterval(function() {
            var likeButton2 = document.querySelector('.gtm-remove-from-wishlist');
            if (likeButton2) {
              clearInterval(checkButtonInterval); // 확인 후 주기 중지
              clearInterval(window.checkButtonInterval2); // 확인 후 주기 중지
              window.flutter_inappwebview.callHandler('onLikeStatusChecked', true);
            }
          }, 1000);
        })();
      ''');

        loadingProgress.value = 1.0;
      },
      onWebViewCreated: (webController) {
        webController.addJavaScriptHandler(
          handlerName: 'onLikeStatusChecked',
          callback: (args) async {
            bool isLiked = args[0];
            if (isLiked) {
              //Get.snackbar("알림", "좋아요가 설정되었습니다.");
              missionEnd(missionNumber.value);
            }
          },
        );
      },
    );
  }

  Widget buildWebViewMusinsaBrandLike(String url) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      onLoadStop: (webController, webUrl) async {
        await webController.evaluateJavascript(source: '''
        (function() {
          if (window.isLikeScriptInitialized) {
            return; // 스크립트가 이미 초기화되었으면 다시 실행하지 않음
          }
          window.isLikeScriptInitialized = true; // 스크립트가 처음 실행됨을 표시

          function applyRedBorderAndClickEvent() {
            var likeButton = document.querySelector('.gtm-add-to-likelist');
            if (likeButton && !likeButton.hasAttribute('data-event-added')) {
              likeButton.style.border = "2px solid red";
              likeButton.style.padding = "4px";
              likeButton.setAttribute('data-event-added', 'true');

              likeButton.addEventListener('click', function(event) {
                setTimeout(function() {
                  var isLiked = likeButton.classList.contains('gtm-remove-from-likelist');
                  window.flutter_inappwebview.callHandler('onLikeStatusChecked', isLiked);
                }, 1000);
              });
            }
          }

          // MutationObserver로 버튼 상태 변화를 감지하여 이벤트 재등록
          var observer = new MutationObserver(function(mutations) {
            mutations.forEach(function(mutation) {
              if (mutation.type === 'attributes' && mutation.target.classList.contains('gtm-add-to-likelist')) {
                applyRedBorderAndClickEvent();
              }
            });
          });

          // 좋아요 버튼이 존재할 때 MutationObserver를 통해 상태 감시 시작
          var likeButton = document.querySelector('.gtm-add-to-likelist');
          if (likeButton) {
            applyRedBorderAndClickEvent();
            observer.observe(likeButton, { attributes: true });
          }

          // 주기적으로 좋아요 버튼이 생기는지 확인
          var checkButtonInterval = setInterval(function() {
            var likeButton = document.querySelector('.gtm-add-to-likelist');
            if (likeButton && !likeButton.hasAttribute('data-event-added')) {
              applyRedBorderAndClickEvent();
              observer.observe(likeButton, { attributes: true });
              clearInterval(checkButtonInterval); // 확인 후 주기 중지
              clearInterval(window.checkButtonInterval2); // 확인 후 주기 중지
            }
          }, 1000);

          // 주기적으로 gtm-remove-from-likelist 버튼이 생기는지 확인
          window.checkButtonInterval2 = setInterval(function() {
            var likeButton2 = document.querySelector('.gtm-remove-from-likelist');
            if (likeButton2) {
              clearInterval(window.checkButtonInterval2); // 확인 후 주기 중지
              clearInterval(checkButtonInterval); // 확인 후 주기 중지
              window.flutter_inappwebview.callHandler('onLikeStatusChecked', true);
            }
          }, 1000);
        })();
      ''');

        loadingProgress.value = 1.0;
      },
      onWebViewCreated: (webController) {
        webController.addJavaScriptHandler(
          handlerName: 'onLikeStatusChecked',
          callback: (args) async {
            bool isLiked = args[0];
            if (isLiked) {
              //Get.snackbar("알림", "좋아요가 설정되었습니다.");
              missionEnd(missionNumber.value);
            }
          },
        );
      },
    );
  }

  Widget buildWebViewMusinsaBrandLikeAnd(String url) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        domStorageEnabled: true,
        userAgent: "Mozilla/5.0 (Linux; Android 10; SM-G960N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.91 Mobile Safari/537.36",
      ),
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        var uri = navigationAction.request.url;

        if (uri != null && uri.scheme == "intent") {
          try {
            final fallbackUrl = Uri.decodeFull(uri.toString()).split("S.browser_fallback_url=").last.split(";end").first;

            // 내부 WebView에서 로드
            await controller.loadUrl(urlRequest: URLRequest(url: WebUri(fallbackUrl)));
          } catch (e) {
            print("Fallback URL 처리 실패: $e");
          }
          return NavigationActionPolicy.CANCEL; // 원래 로드 취소
        }

        return NavigationActionPolicy.ALLOW; // WebView에서 계속 로드
      },
      onLoadStop: (webController, webUrl) async {
        if (webUrl != null) {
          print("페이지 로드 완료: ${webUrl.toString()}");
        }

        await webController.evaluateJavascript(source: '''
        (function() {
          if (window.isLikeScriptInitialized) {
            return; // 스크립트가 이미 초기화되었으면 다시 실행하지 않음
          }
          window.isLikeScriptInitialized = true; // 스크립트가 처음 실행됨을 표시

          function applyRedBorderAndClickEvent() {
            var likeButton = document.querySelector('.gtm-add-to-likelist');
            if (likeButton && !likeButton.hasAttribute('data-event-added')) {
              likeButton.style.border = "2px solid red";
              likeButton.style.padding = "4px";
              likeButton.setAttribute('data-event-added', 'true');

              likeButton.addEventListener('click', function(event) {
                setTimeout(function() {
                  var isLiked = likeButton.classList.contains('gtm-remove-from-likelist');
                  window.flutter_inappwebview.callHandler('onLikeStatusChecked', isLiked);
                }, 1000);
              });
            }
          }

          var observer = new MutationObserver(function(mutations) {
            mutations.forEach(function(mutation) {
              if (mutation.type === 'attributes' && mutation.target.classList.contains('gtm-add-to-likelist')) {
                applyRedBorderAndClickEvent();
              }
            });
          });

          var likeButton = document.querySelector('.gtm-add-to-likelist');
          if (likeButton) {
            applyRedBorderAndClickEvent();
            observer.observe(likeButton, { attributes: true });
          }

          var checkButtonInterval = setInterval(function() {
            var likeButton = document.querySelector('.gtm-add-to-likelist');
            if (likeButton && !likeButton.hasAttribute('data-event-added')) {
              applyRedBorderAndClickEvent();
              observer.observe(likeButton, { attributes: true });
              clearInterval(checkButtonInterval);
              clearInterval(window.checkButtonInterval2);
            }
          }, 1000);

          window.checkButtonInterval2 = setInterval(function() {
            var likeButton2 = document.querySelector('.gtm-remove-from-likelist');
            if (likeButton2) {
              clearInterval(window.checkButtonInterval2);
              clearInterval(checkButtonInterval);
              window.flutter_inappwebview.callHandler('onLikeStatusChecked', true);
            }
          }, 1000);
        })();
      ''');
      },
      onWebViewCreated: (webController) {
        webController.addJavaScriptHandler(
          handlerName: 'onLikeStatusChecked',
          callback: (args) async {
            bool isLiked = args[0];
            if (isLiked) {
              print("좋아요가 설정되었습니다.");
              missionEnd(missionNumber.value);
            }
          },
        );
      },
    );
  }

  Widget buildWebViewNaverBrandLike(String url) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      onLoadStop: (webController, webUrl) async {
        await webController.evaluateJavascript(source: '''
        (function() {
          if (window.isLikeScriptInitialized) {
            return;
          }
          window.isLikeScriptInitialized = true;
          var isInitialLikeChecked = false; // 초기 상태 체크 여부

          function applyRedBorderToLikeButton() {
            var likeButtonContainer = document.querySelector('.bd_2hUub');
            var likeButton = likeButtonContainer ? likeButtonContainer.querySelector('._nlog_impression_element') : null;
            
            if (likeButton && !likeButton.hasAttribute('data-styled')) {
              likeButton.style.border = "2px solid red";
              likeButton.style.padding = "4px";
              likeButton.setAttribute('data-styled', 'true');
            }

            // 클릭 이벤트가 한 번만 등록되도록 확인
            if (likeButton && !likeButton.hasAttribute('data-click-event-added')) {
              likeButton.setAttribute('data-click-event-added', 'true');
              likeButton.addEventListener('click', function() {
                var isLiked = likeButton.getAttribute('aria-pressed') === 'true';
                if (isLiked) {
                  window.flutter_inappwebview.callHandler('onLikeClicked');
                }
              });
            }

            // 초기 로딩 시 좋아요 상태를 한 번만 확인
            if (likeButton && !isInitialLikeChecked && likeButton.getAttribute('aria-pressed') === 'true') {
              isInitialLikeChecked = true;
              window.flutter_inappwebview.callHandler('onLikeClicked');
            }
          }

          var observer = new MutationObserver(function(mutations) {
            mutations.forEach(function(mutation) {
              if (mutation.type === 'childList' || mutation.type === 'attributes') {
                applyRedBorderToLikeButton();
              }
            });
          });

          observer.observe(document.body, { childList: true, subtree: true, attributes: true });

          applyRedBorderToLikeButton();
        })();
      ''');

        loadingProgress.value = 1.0;
      },
      onWebViewCreated: (webController) {
        webController.addJavaScriptHandler(
          handlerName: 'onLikeClicked',
          callback: (args) async {
            if (!Get.isSnackbarOpen) {
              //Get.snackbar("알림", "좋아요가 설정되었습니다.");
              missionEnd(missionNumber.value);
            }
          },
        );
      },
    );
  }

  Widget buildWebViewNaverBrandAram(String url) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      onLoadStop: (webController, webUrl) async {
        await webController.evaluateJavascript(source: '''
        (function() {
          let notificationSent = false; // 중복 알림 방지 플래그

          function applyRedBorderAndCheckNotificationStatus() {
            // "알림받기" 버튼을 찾습니다
            const notificationButton = document.querySelector("._1y4AMC2nZN button");
            if (notificationButton) {
              // 알림받기 버튼의 aria-pressed 속성 확인
              if (!notificationSent && notificationButton.getAttribute("aria-pressed") === "true") {
                // aria-pressed가 true인 경우, 좋아요 알림 처리
                notificationSent = true;
                window.flutter_inappwebview.callHandler('onNotificationSubscribed');
              }

              notificationButton.style.border = "2px solid red"; // "알림받기" 버튼에 빨간 테두리 추가
              notificationButton.style.padding = "4px"; // 가시성을 위해 패딩 추가
              notificationButton.scrollIntoView({ behavior: 'smooth', block: 'center' }); // "알림받기" 버튼으로 화면 스크롤

              // "알림받기" 버튼에 클릭 이벤트 추가하여 상태를 다시 확인
              notificationButton.onclick = function() {
                setTimeout(checkNotificationButtonStatus, 500); // 상태 변화를 확인하기 위해 대기
              };

              // "알림받기" 버튼에 클릭 이벤트 추가하여 팝업에서의 "알림받기" 버튼에 테두리 추가
              notificationButton.onclick = function() {
                setTimeout(applyRedBorderToPopupNotificationButton, 500); // 팝업이 나타날 때까지 대기
              };
            }
          }

          function checkNotificationButtonStatus() {
            const notificationButton = document.querySelector("._1y4AMC2nZN button");
            if (!notificationSent && notificationButton && notificationButton.getAttribute("aria-pressed") === "true") {
              // 클릭 후 상태가 변경되어 "알림받기"가 활성화되었을 때 스낵바 알림 표시
              notificationSent = true;
              window.flutter_inappwebview.callHandler('onNotificationSubscribed');
            }
          }

          function applyRedBorderToPopupNotificationButton() {
            // 팝업에서 "알림받기" 버튼이 포함된 div를 찾습니다
            const popupContainer = document.querySelector("._1wucMvoXkm");
            if (popupContainer) {
              const buttons = popupContainer.querySelectorAll("button");
              if (buttons.length > 1) {
                const secondButton = buttons[1]; // 두 번째 버튼 선택
                secondButton.style.border = "2px solid red"; // 두 번째 버튼에 빨간 테두리 추가
                secondButton.style.padding = "4px"; // 가시성을 위해 패딩 추가

                // 두 번째 버튼에 클릭 이벤트 추가하여 스낵바 표시
                secondButton.onclick = function() {
                  window.flutter_inappwebview.callHandler('onPopupNotificationButtonClicked');
                };
              }
            }
          }

          // DOM 변화를 감지하여 동적으로 "알림받기" 버튼 스타일 적용
          const observer = new MutationObserver((mutations) => {
            mutations.forEach((mutation) => {
              applyRedBorderAndCheckNotificationStatus();
            });
          });

          // DOM 변화를 감시하여 "알림받기" 버튼을 동적으로 찾습니다
          observer.observe(document.body, { childList: true, subtree: true });

          // 초기 상태에서 "알림받기" 버튼에 테두리와 스크롤 및 상태 확인 적용
          applyRedBorderAndCheckNotificationStatus();
        })();
      ''');
        loadingProgress.value = 1.0;
      },
      onWebViewCreated: (webController) {
        webController.addJavaScriptHandler(
          handlerName: 'onNotificationSubscribed',
          callback: (args) {
            // 알림받는 중인 경우 좋아요 알림 처리
            //Get.snackbar('알림', '이미 알림받기로 설정되었습니다.');
            missionEnd(missionNumber.value);
          },
        );
      },
    );
  }

  Widget buildWebViewOliveYoungWish(String url) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      onLoadStop: (webController, webUrl) async {
        await webController.evaluateJavascript(source: '''
      (function() {
        if (window.isObserverSet) return;
        window.isObserverSet = true;

        const targetButton = document.querySelector('.btn--zzim.goodsJeem.goods_wish');
        if (targetButton) {
          targetButton.style.border = '2px solid red';
          targetButton.scrollIntoView({ behavior: 'smooth', block: 'center' });

          let isWishActivated = false;

          if (targetButton.innerText.includes('좋아요 선택됨')) {
            isWishActivated = true;
            window.flutter_inappwebview.callHandler('onWishButtonActivated');
          }

          const observer = new MutationObserver((mutations) => {
            mutations.forEach((mutation) => {
              if (targetButton.innerText.includes('좋아요 선택됨') && !isWishActivated) {
                isWishActivated = true;
                window.flutter_inappwebview.callHandler('onWishButtonActivated');
                observer.disconnect();
              }
            });
          });

          observer.observe(targetButton, { childList: true, subtree: true });
        }
      })();
      ''');
        loadingProgress.value = 1.0;
      },
      onWebViewCreated: (webController) {
        webController.addJavaScriptHandler(
          handlerName: 'onWishButtonActivated',
          callback: (args) {
            missionEnd(missionNumber.value);
          },
        );
      },
    );
  }

  Widget buildWebViewOliveYoungWishAnd(String url) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        domStorageEnabled: true,
        userAgent: "Mozilla/5.0 (Linux; Android 10; SM-G960N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.91 Mobile Safari/537.36",
      ),
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        var uri = navigationAction.request.url;

        if (uri != null && uri.scheme == "intent") {
          try {
            final fallbackUrl = Uri.decodeFull(uri.toString()).split("S.browser_fallback_url=").last.split(";end").first;

            // 내부 WebView에서 로드
            await controller.loadUrl(urlRequest: URLRequest(url: WebUri(fallbackUrl)));
          } catch (e) {
            print("Fallback URL 처리 실패: $e");
          }
          return NavigationActionPolicy.CANCEL; // 원래 로드 취소
        }

        return NavigationActionPolicy.ALLOW; // WebView에서 계속 로드
      },
      onLoadStop: (webController, webUrl) async {
        if (webUrl != null) {
          print("페이지 로드 완료: ${webUrl.toString()}");
        }

        // `getKakaoAgent` 정의 추가
        await webController.evaluateJavascript(source: '''
        if (!window.getKakaoAgent) {
          window.getKakaoAgent = function() {
            return "Custom Kakao Agent";
          };
        }
      ''');

        await webController.evaluateJavascript(source: '''
      (function() {
        if (window.isObserverSet) return;
        window.isObserverSet = true;

        const targetButton = document.querySelector('.btn--zzim.goodsJeem.goods_wish');
        if (targetButton) {
          targetButton.style.border = '2px solid red';
          targetButton.scrollIntoView({ behavior: 'smooth', block: 'center' });

          let isWishActivated = false;

          if (targetButton.innerText.includes('좋아요 선택됨')) {
            isWishActivated = true;
            window.flutter_inappwebview.callHandler('onWishButtonActivated');
          }

          const observer = new MutationObserver((mutations) => {
            mutations.forEach((mutation) => {
              if (targetButton.innerText.includes('좋아요 선택됨') && !isWishActivated) {
                isWishActivated = true;
                window.flutter_inappwebview.callHandler('onWishButtonActivated');
                observer.disconnect();
              }
            });
          });

          observer.observe(targetButton, { childList: true, subtree: true });
        }
      })();
      ''');
        loadingProgress.value = 1.0;
      },
      onWebViewCreated: (webController) {
        webController.addJavaScriptHandler(
          handlerName: 'onWishButtonActivated',
          callback: (args) {
            missionEnd(missionNumber.value);
          },
        );
      },
      onConsoleMessage: (controller, consoleMessage) {
        print("콘솔 메시지: ${consoleMessage.message}");
        if (consoleMessage.message.contains("getKakaoAgent")) {
          print("Kakao SDK 관련 JavaScript 오류 무시");
        }
      },
    );
  }

  Widget buildWebViewOliveYoungBrandLike(String url) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      onLoadStop: (webController, webUrl) async {
        debugPrint("Brand like onLoadStop");
        await webController.evaluateJavascript(source: '''
        (function() {
          if (window.isObserverSet) return;
          window.isObserverSet = true;

          const likeSpan = document.querySelector('.icon.icobrand');
          const likeATag = document.querySelector('.brand_like.brandTop a');

          if (likeSpan) {
            likeSpan.style.border = '2px solid red';
          }

          if (likeATag && likeATag.classList.contains('on')) {
            window.flutter_inappwebview.callHandler('onBrandLikeActivated');
          }

          const observer = new MutationObserver((mutations) => {
            mutations.forEach((mutation) => {
              if (likeATag && likeATag.classList.contains('on')) {
                window.flutter_inappwebview.callHandler('onBrandLikeActivated');
                observer.disconnect();
              }
            });
          });

          if (likeATag) {
            observer.observe(likeATag, { attributes: true, attributeFilter: ['class'] });
          }
        })();
        ''');
        loadingProgress.value = 1.0;
      },
      onWebViewCreated: (webController) {
        webController.addJavaScriptHandler(
          handlerName: 'onBrandLikeActivated',
          callback: (args) {
            debugPrint("Brand like activated");
          },
        );
      },
    );
  }

  Widget buildWebViewOliveYoungBrandLikeAnd(String url) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        domStorageEnabled: true,
        userAgent: "Mozilla/5.0 (Linux; Android 10; SM-G960N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.91 Mobile Safari/537.36",
      ),
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        var uri = navigationAction.request.url;

        if (uri != null && uri.scheme == "intent") {
          try {
            final fallbackUrl = Uri.decodeFull(uri.toString()).split("S.browser_fallback_url=").last.split(";end").first;

            // 내부 WebView에서 로드
            await controller.loadUrl(urlRequest: URLRequest(url: WebUri(fallbackUrl)));
          } catch (e) {
            print("Fallback URL 처리 실패: $e");
          }
          return NavigationActionPolicy.CANCEL; // 원래 로드 취소
        }

        return NavigationActionPolicy.ALLOW; // WebView에서 계속 로드
      },
      onLoadStop: (webController, webUrl) async {
        if (webUrl != null) {
          print("페이지 로드 완료: ${webUrl.toString()}");
        }

        await webController.evaluateJavascript(source: '''
        (function() {
          if (window.isObserverSet) return;
          window.isObserverSet = true;

          const likeSpan = document.querySelector('.icon.icobrand');
          const likeATag = document.querySelector('.brand_like.brandTop a');

          if (likeSpan) {
            likeSpan.style.border = '2px solid red';
          }

          if (likeATag && likeATag.classList.contains('on')) {
            window.flutter_inappwebview.callHandler('onBrandLikeActivated');
          }

          const observer = new MutationObserver((mutations) => {
            mutations.forEach((mutation) => {
              if (likeATag && likeATag.classList.contains('on')) {
                window.flutter_inappwebview.callHandler('onBrandLikeActivated');
                observer.disconnect();
              }
            });
          });

          if (likeATag) {
            observer.observe(likeATag, { attributes: true, attributeFilter: ['class'] });
          }
        })();
        ''');
        loadingProgress.value = 1.0;
      },
      onWebViewCreated: (webController) {
        webController.addJavaScriptHandler(
          handlerName: 'onBrandLikeActivated',
          callback: (args) {
            debugPrint("Brand like activated");
          },
        );
      },
    );
  }

  Widget buildWebViewOHouseScrap(String url) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      onLoadStop: (webController, webUrl) async {
        // 기존 JavaScript 작업 유지
        await webController.evaluateJavascript(source: '''
      (function() {
        if (window.isObserverSet) return;
        window.isObserverSet = true;

        const scrapButton = document.querySelector('.production-selling-floating-content__scrap');
        if (scrapButton) {
          scrapButton.style.border = '2px solid red';

          let isScrapActivated = false;

          if (scrapButton.classList.contains('production-selling-floating-content__scrap--active')) {
            isScrapActivated = true;
            window.flutter_inappwebview.callHandler('onScrapButtonActivated');
          }

          const observer = new MutationObserver((mutations) => {
            mutations.forEach((mutation) => {
              if (scrapButton.classList.contains('production-selling-floating-content__scrap--active') && !isScrapActivated) {
                isScrapActivated = true;
                window.flutter_inappwebview.callHandler('onScrapButtonActivated');
                observer.disconnect();
              }
            });
          });

          observer.observe(scrapButton, { attributes: true, attributeFilter: ['class'] });
        }
      })();
      ''');
        loadingProgress.value = 1.0;
      },
      onWebViewCreated: (webController) {
        webController.addJavaScriptHandler(
          handlerName: 'onScrapButtonActivated',
          callback: (args) {
            // 알림 표시 또는 특정 작업 수행
            missionEnd(missionNumber.value);
          },
        );
      },
    );
  }

  Widget buildWebViewOHouseScrapAnd(String url) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        domStorageEnabled: true,
        userAgent: "Mozilla/5.0 (Linux; Android 10; SM-G960N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.91 Mobile Safari/537.36",
      ),
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        var uri = navigationAction.request.url;

        if (uri != null && uri.scheme == "intent") {
          final fallbackUrl = Uri.decodeFull(uri.toString()).split("S.browser_fallback_url=").last.split(";end").first;

          if (await canLaunchUrl(Uri.parse(fallbackUrl))) {
            await launchUrl(Uri.parse(fallbackUrl));
          }
          return NavigationActionPolicy.CANCEL;
        }

        return NavigationActionPolicy.ALLOW;
      },
      onLoadStop: (webController, webUrl) async {
        if (webUrl != null) {
          print("페이지 로드 완료: ${webUrl.toString()}");
        }

        // `getKakaoAgent` 정의 추가
        await webController.evaluateJavascript(source: '''
        if (!window.getKakaoAgent) {
          window.getKakaoAgent = function() {
            return "Custom Kakao Agent";
          };
        }
      ''');

        // JavaScript 작업 유지
        await webController.evaluateJavascript(source: '''
        (function() {
          if (window.isObserverSet) return;
          window.isObserverSet = true;

          const scrapButton = document.querySelector('.production-selling-floating-content__scrap');
          if (scrapButton) {
            scrapButton.style.border = '2px solid red';

            let isScrapActivated = false;

            if (scrapButton.classList.contains('production-selling-floating-content__scrap--active')) {
              isScrapActivated = true;
              window.flutter_inappwebview.callHandler('onScrapButtonActivated');
            }

            const observer = new MutationObserver((mutations) => {
              mutations.forEach((mutation) => {
                if (scrapButton.classList.contains('production-selling-floating-content__scrap--active') && !isScrapActivated) {
                  isScrapActivated = true;
                  window.flutter_inappwebview.callHandler('onScrapButtonActivated');
                  observer.disconnect();
                }
              });
            });

            observer.observe(scrapButton, { attributes: true, attributeFilter: ['class'] });
          }
        })();
      ''');
        loadingProgress.value = 1.0;
      },
      onWebViewCreated: (webController) {
        webController.addJavaScriptHandler(
          handlerName: 'onScrapButtonActivated',
          callback: (args) {
            missionEnd(missionNumber.value);
          },
        );
      },
      onConsoleMessage: (controller, consoleMessage) {
        print("콘솔 메시지: ${consoleMessage.message}");
        if (consoleMessage.message.contains("getKakaoAgent")) {
          print("Kakao SDK 관련 JavaScript 오류 무시");
        }
      },
    );
  }
}

import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'home_page_model.dart';
export 'home_page_model.dart';

class TimePickerDialog24Hour extends StatefulWidget {
  final TimeOfDay initialTime;

  const TimePickerDialog24Hour({
    Key? key,
    required this.initialTime,
  }) : super(key: key);

  @override
  _TimePickerDialog24HourState createState() => _TimePickerDialog24HourState();
}

class _TimePickerDialog24HourState extends State<TimePickerDialog24Hour> {
  late int selectedHour;

  @override
  void initState() {
    super.initState();
    selectedHour = widget.initialTime.hour;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 280,
              height: 280,
              child: GestureDetector(
                onTapUp: (TapUpDetails details) {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final localPosition = box.globalToLocal(details.globalPosition);
                  final center = Offset(box.size.width / 2, box.size.height / 2);
                  
                  // 터치 지점과 중심점 사이의 각도 계산
                  final angle = math.atan2(
                    localPosition.dx - center.dx,
                    -(localPosition.dy - center.dy),
                  );
                  
                  // 12시를 기준으로 시간 계산
                  var hour = ((angle / (2 * math.pi) * 24) + 12).round();
                  if (hour > 24) hour -= 24;
                  if (hour == 0) hour = 24;
                  
                  setState(() {
                    selectedHour = hour;
                  });
                },
                child: CustomPaint(
                  painter: Clock24HourPainter(
                    selectedHour: selectedHour,
                    onHourSelected: (hour) {
                      setState(() {
                        selectedHour = hour;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('취소', style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, TimeOfDay(hour: selectedHour, minute: 0));
                  },
                  child: Text('확인', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Clock24HourPainter extends CustomPainter {
  final int selectedHour;
  final Function(int) onHourSelected;

  Clock24HourPainter({
    required this.selectedHour,
    required this.onHourSelected,
  });

  @override
  bool hitTest(Offset position) => true;

  void handleTapUp(TapUpDetails details, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final touchPoint = details.localPosition;
    
    // 터치 지점과 중심점 사이의 각도 계산
    final angle = math.atan2(
      touchPoint.dx - center.dx,
      -(touchPoint.dy - center.dy),
    );
    
    // 12시를 기준으로 시간 계산
    var hour = ((angle / (2 * math.pi) * 24) + 12).round();
    if (hour > 24) hour -= 24;
    if (hour == 0) hour = 24;
    
    onHourSelected(hour);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // 시계 외곽선
    final paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawCircle(center, radius - 10, paint);

    // 시간 숫자
    final textPainter = TextPainter(
      textDirection: ui.TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int hour = 1; hour <= 24; hour++) {
      // 시계는 12시부터 시작하도록 각도 조정
      final angle = (hour - 12) * (2 * math.pi / 24);
      final offset = Offset(
        center.dx + (radius - 30) * math.sin(angle),
        center.dy - (radius - 30) * math.cos(angle),
      );

      String hourText = hour.toString().padLeft(2, '0');
      textPainter.text = TextSpan(
        text: hourText,
        style: TextStyle(
          color: selectedHour == hour ? Colors.blue : Colors.black,
          fontSize: 14,
          fontWeight: selectedHour == hour ? FontWeight.bold : FontWeight.normal,
        ),
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        offset.translate(-textPainter.width / 2, -textPainter.height / 2),
      );
    }

    // 선택된 시간 표시
    if (selectedHour > 0) {
      final angle = (selectedHour - 12) * (2 * math.pi / 24);
      final handPaint = Paint()
        ..color = Colors.blue
        ..strokeWidth = 2;
      
      canvas.drawLine(
        center,
        Offset(
          center.dx + (radius - 40) * math.sin(angle),
          center.dy - (radius - 40) * math.cos(angle),
        ),
        handPaint,
      );
    }
  }

  @override
  bool shouldRepaint(Clock24HourPainter oldDelegate) {
    return oldDelegate.selectedHour != selectedHour;
  }
}

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    _model.nameTextController ??= TextEditingController();
    _model.nameFocusNode ??= FocusNode();

    _model.birthTextController ??= TextEditingController();
    _model.birthFocusNode ??= FocusNode();

    _model.birthtimeTextController ??= TextEditingController();
    _model.birthtimeFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFF6F6F6),
        appBar: AppBar(
          backgroundColor: Color(0xFF105DFB),
          automaticallyImplyLeading: false,
          title: Text(
            '2025년 종합 신년 운세 분석',
            style: FlutterFlowTheme.of(context).headlineLarge.override(
                  fontFamily: 'Inter Tight',
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  letterSpacing: 0.0,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Discover Your Path',
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                          fontFamily: 'Readex Pro',
                          color: Color(0xFF12151C),
                          fontSize: 20.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Text(
                    '관상과 사주를 분석하는 복합적인 운세 분석 시스템입니다.  2025년',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          color: Color(0xFF5A5C60),
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                  Material(
                    color: Colors.transparent,
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 1.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 20.0, 20.0, 20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: 120.0,
                              height: 120.0,
                              decoration: BoxDecoration(
                                color: Color(0x4C105DFB),
                                borderRadius: BorderRadius.circular(60.0),
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(60.0),
                                    child: _model.selectedImage != null
                                        ? Image.memory(
                                            _model.selectedImage!,
                                            width: 120.0,
                                            height: 120.0,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            'https://images.unsplash.com/photo-1606247193592-53da505571f8?w=500&h=500',
                                            width: 120.0,
                                            height: 120.0,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      final ImagePicker picker = ImagePicker();
                                      final XFile? image = await picker.pickImage(
                                        source: ImageSource.gallery,
                                        maxWidth: 1500,
                                        maxHeight: 1500,
                                      );
                                      
                                      if (image != null) {
                                        final bytes = await image.readAsBytes();
                                        final decodedImage = img.decodeImage(bytes);
                                        
                                        if (decodedImage != null) {
                                          // 이미지 크기 조정
                                          final resizedImage = img.copyResize(
                                            decodedImage,
                                            width: 1500,
                                            height: (1500 * decodedImage.height / decodedImage.width).round(),
                                          );
                                          
                                          // 이미지를 JPEG로 인코딩 (품질: 85)
                                          final processedBytes = img.encodeJpg(resizedImage, quality: 85);
                                          
                                          setState(() {
                                            _model.selectedImage = Uint8List.fromList(processedBytes);
                                          });
                                        }
                                      }
                                    },
                                    child: Container(
                                      width: 120.0,
                                      height: 120.0,
                                      decoration: BoxDecoration(
                                        color: _model.selectedImage != null 
                                            ? Colors.transparent
                                            : Color(0x33000000),
                                        borderRadius: BorderRadius.circular(60.0),
                                      ),
                                      child: _model.selectedImage == null
                                          ? Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.camera_alt,
                                                    color: Colors.white,
                                                    size: 30.0,
                                                  ),
                                                  Text(
                                                    'Add Photo',
                                                    style: FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight: FontWeight.normal,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : SizedBox(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                TextFormField(
                                  controller: _model.nameTextController,
                                  focusNode: _model.nameFocusNode,
                                  autofocus: false,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: '당신의 이름을 입력해주세요',
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          color: Color(0xFF12151C),
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                    hintStyle: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          fontFamily: 'Inter',
                                          color: Color(0xFF12151C),
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                        ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFE0E3E7),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    suffixIcon: Icon(
                                      Icons.person,
                                    ),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        fontFamily: 'Inter',
                                        color: Color(0xFF12151C),
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                      ),
                                  minLines: 1,
                                  validator: _model.nameTextControllerValidator
                                      .asValidator(context),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: TextFormField(
                                          controller:
                                              _model.birthTextController,
                                          focusNode: _model.birthFocusNode,
                                          autofocus: false,
                                          readOnly: true,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: '생년월일',
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Inter',
                                                      color: Color(0xFF12151C),
                                                      fontSize: 14.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .override(
                                                      fontFamily: 'Inter',
                                                      color: Color(0xFF12151C),
                                                      fontSize: 16.0,
                                                      letterSpacing: 0.0,
                                                    ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFFE0E3E7),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            suffixIcon: InkWell(
                                              onTap: () async {
                                                final DateTime? picked = await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(1900),
                                                  lastDate: DateTime.now(),
                                                  locale: const Locale('ko', 'KR'),
                                                  builder: (context, child) {
                                                    return Theme(
                                                      data: Theme.of(context).copyWith(
                                                        colorScheme: ColorScheme.light(
                                                          primary: FlutterFlowTheme.of(context).primary,
                                                          onPrimary: Colors.white,
                                                          surface: Colors.white,
                                                          onSurface: Colors.black,
                                                        ),
                                                        textButtonTheme: TextButtonThemeData(
                                                          style: TextButton.styleFrom(
                                                            foregroundColor: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      child: child!,
                                                    );
                                                  },
                                                );
                                                if (picked != null) {
                                                  setState(() {
                                                    _model.birthTextController?.text = 
                                                        DateFormat('yyyy-MM-dd').format(picked);
                                                  });
                                                }
                                              },
                                              child: Icon(
                                                Icons.calendar_today,
                                              ),
                                            ),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                fontFamily: 'Inter',
                                                color: Color(0xFF12151C),
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                              ),
                                          minLines: 1,
                                          keyboardType: TextInputType.datetime,
                                          validator: _model
                                              .birthTextControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: TextFormField(
                                          controller:
                                              _model.birthtimeTextController,
                                          focusNode: _model.birthtimeFocusNode,
                                          autofocus: false,
                                          readOnly: true,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: '태어난시각',
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Inter',
                                                      color: Color(0xFF12151C),
                                                      fontSize: 14.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .override(
                                                      fontFamily: 'Inter',
                                                      color: Color(0xFF12151C),
                                                      fontSize: 16.0,
                                                      letterSpacing: 0.0,
                                                    ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFFE0E3E7),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            suffixIcon: InkWell(
                                              onTap: () async {
                                                final TimeOfDay? time = await showDialog<TimeOfDay>(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return Theme(
                                                      data: Theme.of(context).copyWith(
                                                        dialogBackgroundColor: FlutterFlowTheme.of(context).primary,
                                                      ),
                                                      child: TimePickerDialog24Hour(
                                                        initialTime: TimeOfDay.now(),
                                                      ),
                                                    );
                                                  },
                                                );
                                                
                                                if (time != null) {
                                                  setState(() {
                                                    _model.birthtimeTextController?.text = 
                                                        '${time.hour.toString().padLeft(2, '0')}:00~${time.hour.toString().padLeft(2, '0')}:59';
                                                  });
                                                }
                                              },
                                              child: Icon(
                                                Icons.access_time,
                                              ),
                                            ),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                fontFamily: 'Inter',
                                                color: Color(0xFF12151C),
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                              ),
                                          minLines: 1,
                                          keyboardType: TextInputType.datetime,
                                          validator: _model
                                              .birthtimeTextControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                FlutterFlowChoiceChips(
                                  options: [
                                    ChipData('남성'),
                                    ChipData('여성'),
                                    ChipData('기타')
                                  ],
                                  onChanged: (val) => setState(
                                      () => _model.choiceChipsValue = val?.first),
                                  selectedChipStyle: ChipStyle(
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).primary,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          color: Colors.white,
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                    iconColor: Colors.white,
                                    iconSize: 18.0,
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  unselectedChipStyle: ChipStyle(
                                    backgroundColor: Colors.white,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          color: Color(0xFF323B4B),
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                    iconColor: Color(0xFF323B4B),
                                    iconSize: 18.0,
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderColor: Color(0xFFE0E3E7),
                                    borderWidth: 1.0,
                                  ),
                                  chipSpacing: 12.0,
                                  rowSpacing: 12.0,
                                  multiselect: false,
                                  initialized: _model.choiceChipsValue != null,
                                  alignment: WrapAlignment.start,
                                  controller: _model.choiceChipsValueController ??=
                                      FormFieldController<List<String>>(
                                    ['남성'],
                                  ),
                                  wrapped: true,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 1.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 20.0, 20.0, 20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello World',
                              textAlign: TextAlign.start,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            Text(
                              'What would you like to know?',
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: 'Readex Pro',
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              direction: Axis.horizontal,
                              runAlignment: WrapAlignment.start,
                              verticalDirection: VerticalDirection.down,
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xB3FFFFFF),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 16.0, 8.0, 16.0),
                                    child: Text(
                                      'Wealth',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            color: Color(0xFF12151C),
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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

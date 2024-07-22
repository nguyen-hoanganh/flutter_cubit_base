# base_flutter_core

A new Flutter project. levik <Hoang Anh> dựng base để dùng cho các ứng dụng có độ phức tạp trung bình

## <a name="part1"></a> Cấu trúc thư mục
*  `common` : Thư mục bao gồm các configs, widgets chung, extension, manaager, route, base_screen
*  `container` : Thư mục bao gồm các page, trong page có 2 thành phần cubit và page
*  `datasource` : Thư mục bao gồm các models, network setting

## sử dụng project project 
1: sử dụng make build-runner, make generate
## Networking
## <a name="part1"></a> Cấu trúc: 
* api_service -> bao gồm các abstract class enpoint sử dụng RestApi của retrofit (chủ yếu khai báo và sử dụng ở AppApi)
Func exp:
  @POST('/mobile/verifyUsername')
  Future<HttpResponse<VerifyUsernameResponse>> verifyUsername(
        @Body() VerifyUsernameRequest request, {
    @Header(NetworkCustomKeys.isShowLoading) bool? isShowLoading,
    @Header(NetworkCustomKeys.isShowDefaultErrorDialog)
        bool? isShowDefaultErrorDialog,
    @Header(NetworkCustomKeys.isShowDefaultDioErrorDialog)
        bool? isShowDefaultDioErrorDialog,
    @Header(NetworkCustomKeys.whitelistErrorCode)
        List<String>? whitelistErrorCode,
  }
  );

* Trong đó: 
isShowLoading: là trạng thái của việc show  loading khi call service.
isShowDefaultErrorDialog: Là trạng thái của việc show mặc định lỗi !="00" mặc định là true,
isShowDefaultDioErrorDialog: Là trạng thái show mặc định của DioError
whitelistErrorCode: là List string bao gồm các mã lỗi đặc biệt không muốn show dialog mặc định mà muốn show riêng.

* repositories -> bao gồm các repositories tương ứng với api service (chủ yếu sử dụng AppRepository)

* Step thực hiện tạo api:
Tạo các request và response tương ứng
Tạo func request trong api service -> run make build-runner để generate file api_...g.dart
Tạo func tại abstract class repository và override func tại class repositoryImpl.

## <a name="part1"></a> Cách sử dụng EXP:
                    final a = await getIt.get<AppRepository>().verifyPassword(
                          VerifyPasswordRequest(
                            username: "testusr1",
                            password: "password",
                            ipAddress: "ipAddress",
                          ),
                          isShowDefaultErrorDialog: true,
                        );


# flutter_base_cubit

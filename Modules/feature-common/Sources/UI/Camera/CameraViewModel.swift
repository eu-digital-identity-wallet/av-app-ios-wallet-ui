@Copyable
struct CameraViewState: ViewState {
  @State var camera: CameraModel
}

final class CameraViewModel<Router: RouterHost>: ViewModel<Router, CameraViewState> {
  @StateObject var camera = CameraModel()

  init(
    router: Router
  ) {
    super.init(router: router,
               initialState: .init(
                camera: CameraModel()
               )
    )
  }

  func backButtonTapped() {
    router.pop()
  }
}

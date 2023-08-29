//
//  ViewController.swift
//  DayByDay
//
//  Created by FUTURE on 2023/08/28.
//

//(미션)유저디폴트 - 코어데이터를 꼭 활용해보고 싶어서 과제는 아니지만 사용했습니다. 따라서 유저디폴트는 랜딩페이지의 컬러theme기능에 적용해보았습니다.
//코드로만 UI 구현해보는 것을 해보고 싶었습니다.
//다른 페이지에서는 스토리보드, 랜딩페이지에서는 코드로만 구현해보았습니다.

import UIKit

class ViewController: UIViewController {
    
    //UI 요소 인스턴스 만들기
    let backgroundImageView = UIImageView()
    let titleLabel = UILabel()
    //let colorTitleLabel = UILabel()✅ 시간 나면 꼭 구현해보기
    let colorsimageViews = [UIImageView(), UIImageView(), UIImageView(), UIImageView()]
    let imageUrls = [
        "https://i.ibb.co/cDVB83q/background-daytime.png",
        "https://i.ibb.co/5khdtP0/background-night.png",
        "https://i.ibb.co/9YKJ39W/background-twilight.png",
        "https://spartacodingclub.kr/css/images/scc-og.jpg"
    ]
    
    
    //화면 그려질 때 처음 한 번 실행되는 함수
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundImageView()
        setupTitleLabel()
        setupImageViews()
        setupConstraints()
    }
    
    
    //배경 이미지뷰 설정 함수
    private func setupBackgroundImageView() {
        //배경이 앱 화면 가득 차도록 설정
        backgroundImageView.frame = self.view.bounds
        //이미지 삽입 설정
        backgroundImageView.contentMode = .scaleAspectFill
        //화면에 추가. 여기서 self는 ViewController 인스턴스
        self.view.addSubview(backgroundImageView)
    }
    
    
    //타이틀 라벨 설정 함수
    private func setupTitleLabel() {
        //제목
        titleLabel.text = "Choose Your Mood"
        //컬러
        titleLabel.textColor = .white.withAlphaComponent(0.9)
        //가운데 정렬
        titleLabel.textAlignment = .center
        //폰트 설정
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .light)
        //화면에 추가. 여기서 self는 ViewController 인스턴스
        self.view.addSubview(titleLabel)
    }
    
    
    //컬러 theme 이미지뷰 설정 함수
    private func setupImageViews() {
        for (index, imageView) in colorsimageViews.enumerated() {
            //배열 내 각 이미지 뷰에 대응하는 URL을 가져오기 위함
            imageView.tag = index
            //이미지 어떻게 채울지
            imageView.contentMode = .scaleAspectFill
            //둥글기 (지름이 50이니까 그 절반인 25를 입력하면 원이 됨)
            imageView.layer.cornerRadius = 25
            //뷰의 경계 기준으로 채우기
            imageView.clipsToBounds = true
            
            //이미지뷰에 해당하는 URL 연결
            loadImage(for: imageView, with: imageUrls[index])
            
            //제스처 인식기 생성, self는 ViewController를 뜻함
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            imageView.addGestureRecognizer(tapGesture)
            //탭 제스쳐 활성화. (기본적으로 비활성화 되어 있음 풀어줘야해)
            imageView.isUserInteractionEnabled = true
            self.view.addSubview(imageView)
            
            //블러효과 : dark
            let blurEffect = UIBlurEffect(style: .dark)
            //블러효과 화면 생성
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //블러효과 투명도
            blurEffectView.alpha = 0.2
            //블러효과 크기는 화면에 가득 차도록
            blurEffectView.frame = backgroundImageView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            //블러효과 추가하기
            backgroundImageView.addSubview(blurEffectView)
            
        }
    }
    
    
    //이미지뷰에 이미지 로드
    //✅시간나면 error 정의도 해보기
    private func loadImage(for imageView: UIImageView, with urlString: String) {
        //URL 객체 생성
        if let url = URL(string: urlString) {
            
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                }
            }.resume()
        }
    }
    
    
    //컬러 고르는 이미지뷰 눌렀을 때, 실행되는 메서드
    @objc private func imageTapped(_ sender: UITapGestureRecognizer) {
        if let imageView = sender.view as? UIImageView {
            loadImage(for: backgroundImageView, with: imageUrls[imageView.tag])
        }
    }
    
    
    //오토레이아웃 설정
    private func setupConstraints() {
        //뷰가 자동생성 되지 않도록 꼭 넣어야 하는 코드
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //가로 중심을 x축과 동일하도록
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            //상단 띄우기
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 60)
        ])
        
        //같은 것이 여러개이므로 for문과 enumerated 조합으로 구현 가능
        for (index, imageView) in colorsimageViews.enumerated() {
            //뷰가 자동생성 되지 않도록 꼭 넣어야 하는 코드
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                //가로 중심을 x축과 동일하도록
                imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                //가로 길이
                imageView.widthAnchor.constraint(equalToConstant: 50),
                //세로 길이
                imageView.heightAnchor.constraint(equalToConstant: 50),
                //각 이미지뷰 오토레이아웃 잡기
                imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: CGFloat(100 + (60 * index)))
            ])
        }
    }
    
    
}


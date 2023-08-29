//
//  SetupBackgroundImage.swift
//  DayByDay
//
//  Created by FUTURE on 2023/08/29.
//

import UIKit

class SetupBackgroundImage {
    //배경 이미지뷰 설정 함수
    static func setupBackgroundImageView(imageView: UIImageView, view: UIView) {
        //배경이 앱 화면 가득 차도록 설정
        imageView.frame = view.bounds
        //이미지 삽입 설정
        imageView.contentMode = .scaleAspectFill
        //화면에 추가. 여기서 self는 ViewController 인스턴스
        view.addSubview(imageView)
    }
    
    
    
}

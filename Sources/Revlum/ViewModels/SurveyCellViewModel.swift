//
//  SurveyCellViewModel.swift
//  
//
//  Created by Filip Varda on 14.05.2023..
//

import UIKit
import Foundation

/// ViewModel that manages SurveyTableViewCell logic
final class SurveyCellViewModel {
    public var surveyTitle: String {
        return survey.title
    }
    public var surveyDescription: String {
        return survey.description
    }
    public var surveyRevenue: String {
        return survey.revenue
    }
    private let survey: Survey

    init(survey: Survey) {
        self.survey = survey
    }
    
    //MARK: - Implementation
    public func fetchImage(completion: @escaping(Result<Data, Error>) -> Void) {
        guard let url = URL(string: survey.image) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        RevlumImageLoader.shared.dowloadImage(url: url, completion: completion)
    }
}


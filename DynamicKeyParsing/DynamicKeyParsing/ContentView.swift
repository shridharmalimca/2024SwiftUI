//
//  ContentView.swift
//  DynamicKeyParsing
//
//  Created by Macbook on 14/12/24.
//

import SwiftUI

struct APIProvider {
    static let baseUrl = ""
}

enum HttpMethod: String {
    case post = "POST"
    case get = "GET"
}

protocol APIServiceProvider {
    func fetchLocalJSON<T: Codable>(fileUrl: String, requestType: T.Type) async throws -> T?
}


final class APIServiceManager: APIServiceProvider {
    
    func fetchLocalJSON<T: Codable>(fileUrl: String, requestType: T.Type) async throws -> T? {
        
        guard let url = URL(string: fileUrl) else { throw URLError(.badURL) }
        print("Url")
        print(url)
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(requestType, from: data)
        } catch {
            throw URLError(.badServerResponse)
        }
    }
}

struct WeatherReport: Codable {
    let conditions: String
    let temperature: Int
}

final class ViewModel: ObservableObject {
    @Published var data: [WeatherReport] = []
    let apiService: APIServiceProvider
    
    init(apiService: APIServiceProvider) {
        self.apiService = apiService
    }
    
    func getAllReport() async {
        guard let fileUrl = Bundle.main.path(forResource: "Weather", ofType: "json") else { return }
        print(fileUrl)
        do {
            guard let data = try await self.apiService.fetchLocalJSON(fileUrl: fileUrl, requestType: [WeatherReport].self) else { return }
            self.data = data
        } catch {
            print("Failed to fetch data")
        }
    }
}

final class ViewModelFactory {
    static func createModule() -> ViewModel {
        return ViewModel(apiService: APIServiceManager())
    }
}

struct ContentView: View {
    
    var viewModel: ViewModel = ViewModelFactory.createModule()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
            await viewModel.getAllReport()
            print(viewModel.data)
        }
    }
}

#Preview {
    ContentView()
}

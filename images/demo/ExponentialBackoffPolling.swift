import Foundation

/// 简单的网络请求器
class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    /// async/await 版本请求 JSON
    func getJSON<T: Decodable>(url: String, type: T.Type) async throws -> T {
        guard let requestURL = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: requestURL)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        let decoded = try JSONDecoder().decode(T.self, from: data)
        return decoded
    }
    
    enum NetworkError: Error {
        case invalidURL
        case invalidResponse
        case noData
    }
}

/// 定义 JSON 数据结构
struct TestResponse: Codable {
    let success: Bool
}




let url = "https://niyaoyao.github.io/images/test.json"
        
do {
    let response = try await NetworkManager.shared.getJSON(url: url, type: TestResponse.self)
    if response.success {
        print("请求成功: \(response.success)")
        exit(0)
    } else {
        print("请求成功: \(response.success)")
        exit(-1)
    }
} catch {
    print("请求失败: \(error)")
    exit(-1)
}


RunLoop.main.run()
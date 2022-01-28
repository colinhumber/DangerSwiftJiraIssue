import Danger
import Foundation

public struct DangerSwiftJiraIssue {
    public enum JiraError: Error {
        case missingProjectKey
    }
    
    public enum IssueKeyLocation: String {
        case title = "title"
        case branch = "branch"
    }
    
    internal static let danger = Danger()
    
    public static func jiraIssue(projectKeys: [String], projectURL: URL, issueKeyLocation: IssueKeyLocation, emoji: String = ":link:", messageFormatter: ((String, [String]) -> String)? = nil) throws {
        guard !projectKeys.isEmpty else { throw JiraError.missingProjectKey }

        var textToInspect: String
        
        switch issueKeyLocation {
        case .title:
            textToInspect = danger.github.pullRequest.title
            
        case .branch:
            textToInspect = danger.github.pullRequest.head.ref
        }
        
        let delimitedProjectKeys = "(\(projectKeys.joined(separator: "|")))"
        let issueKeyRegex = try! NSRegularExpression(pattern: "(\(delimitedProjectKeys)-[0-9]+)", options: [.caseInsensitive])
        let matches = issueKeyRegex.matches(in: textToInspect, options: [], range: NSRange(location: 0, length: textToInspect.count))
        let issueKeys = matches
            .map { $0.range(at: 1) }
            .compactMap { Range($0, in: textToInspect) }
            .map { String(textToInspect[$0]) }

        guard !issueKeys.isEmpty else {
            warn("Please add the JIRA issue key to the PR \(issueKeyLocation.rawValue) (eg. \(projectKeys.first!)-123)")
            return
        }

        let issueURLs = issueKeys.map { makeLinkHTML(href: projectURL.appendingPathComponent($0), text: $0) }
        
        // use custom message formatter or default
        if let messageFormatter = messageFormatter {
            message(messageFormatter(emoji, issueURLs))
        }
        else {
            message("\(emoji) \(issueURLs.joined(separator: ", "))")
        }
    }
    
    private static func makeLinkHTML(href: URL, text: String) -> String {
        "<a href='\(href.absoluteString)'>\(text)</a>"
    }
}

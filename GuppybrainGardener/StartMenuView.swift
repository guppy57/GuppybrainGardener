//
//  StartMenuView.swift
//  GuppybrainGardener
//
//  Created by Armaan Gupta on 5/14/25.
//

import SwiftUI

struct StartMenuView: View {
	@State private var selectedDirectoryURL: URL?
	@State private var showDirectoryPicker = false
	@State private var shouldNavigateToMainApp = false
	
	var body: some View {
		VStack(spacing: 30) {
			// App logo/title
			Text("Guppybrain Gardener")
				.font(.system(size: 32, weight: .bold))
				.padding(.top, 40)
			
			Spacer()
			
			// Directory selection
			VStack(spacing: 10) {
				Text("Select your markdown files directory:")
					.font(.headline)
				
				HStack {
					Text(selectedDirectoryURL?.path ?? "No directory selected")
						.lineLimit(1)
						.truncationMode(.middle)
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding()
						.background(Color(NSColor.textBackgroundColor))
						.cornerRadius(6)
					
					Button("Browse") {
						showDirectoryPicker = true
					}
					.fileImporter(
						isPresented: $showDirectoryPicker,
						allowedContentTypes: [.folder],
						allowsMultipleSelection: false
					) { result in
						switch result {
						case .success(let urls):
							if let url = urls.first {
								selectedDirectoryURL = url
								// Get access to the directory
								let success = url.startAccessingSecurityScopedResource()
								if !success {
									print("Failed to access the selected directory")
								}
							}
						case .failure(let error):
							print("Error selecting directory: \(error.localizedDescription)")
						}
					}
				}
			}
			.padding(.horizontal)
			
			Spacer()
			
			// Start button
			Button("Start gardening") {
				shouldNavigateToMainApp = true
			}
			.disabled(selectedDirectoryURL == nil)
			.buttonStyle(.borderedProminent)
			.controlSize(.large)
			.padding(.bottom, 40)
		}
		.frame(width: 500, height: 350)
		.background(Color(NSColor.windowBackgroundColor))
		.onChange(of: shouldNavigateToMainApp) { navigate in
			if navigate && selectedDirectoryURL != nil {
				// Here we would open the new window - we'll implement this connection later
				print("Opening main app with directory: \(selectedDirectoryURL!.path)")
				
				// For now, reset the state
				shouldNavigateToMainApp = false
			}
		}
	}
}

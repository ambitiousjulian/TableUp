//
//  LocationSearchViewModel.swift
//  TableUp
//
//  Location search with MKLocalSearchCompleter
//

import Foundation
import MapKit
import Combine

@MainActor
class LocationSearchViewModel: NSObject, ObservableObject {
    @Published var searchQuery = ""
    @Published var searchResults: [MKLocalSearchCompletion] = []
    @Published var selectedLocation: LocationResult?

    private let searchCompleter = MKLocalSearchCompleter()
    private var cancellables = Set<AnyCancellable>()

    struct LocationResult {
        let name: String
        let address: String
        let coordinate: CLLocationCoordinate2D
    }

    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.resultTypes = [.pointOfInterest, .address]

        // Debounce search query
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }

    private func performSearch(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        searchCompleter.queryFragment = query
    }

    func selectLocation(_ completion: MKLocalSearchCompletion) async {
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)

        do {
            let response = try await search.start()
            guard let item = response.mapItems.first else { return }

            let name = item.name ?? completion.title
            let address = item.placemark.title ?? completion.subtitle
            let coordinate = item.placemark.coordinate

            selectedLocation = LocationResult(
                name: name,
                address: address,
                coordinate: coordinate
            )
        } catch {
            print("Location search error: \(error)")
        }
    }

    func clearSelection() {
        selectedLocation = nil
        searchQuery = ""
        searchResults = []
    }
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    nonisolated func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        Task { @MainActor in
            self.searchResults = completer.results
        }
    }

    nonisolated func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        Task { @MainActor in
            print("Search completer error: \(error)")
            self.searchResults = []
        }
    }
}

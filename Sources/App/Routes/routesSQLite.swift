import Routing
import Vapor

import VaporCountries

import FluentSQLite

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func addSQLiteRoutes(_ router: Router) throws {
  try addVaporCountriesRoutes(for: .sqlite, router: router)
}

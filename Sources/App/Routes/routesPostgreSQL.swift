import Routing
import Vapor

import VaporCountries

import FluentPostgreSQL

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func addPostgreSQLroutes(_ router: Router) throws {
  try addVaporCountriesRoutes(for: .psql, router: router)
}

import Routing
import Vapor

import VaporCountries
import FluentMySQL

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func addMySQLroutes(_ router: Router) throws {
  try addVaporCountriesRoutes(for: .mysql, router: router)
}

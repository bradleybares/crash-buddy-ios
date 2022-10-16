enum Sports: String, CaseIterable, Identifiable {
    case snowboarding
    case skiing
    case biking
    
    var id: FavoriteColor { self }
}
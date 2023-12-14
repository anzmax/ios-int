import UIKit

public struct Post {
    public var author: String
    public var description: String
    public var image: String
    public var likes: Int
    public var views: Int
}

public var posts: [Post] = [
    Post(
        author: NSLocalizedString("Royal Mail", comment: ""),
        description: NSLocalizedString("A special collection of stamps has been issued to mark the 75th anniversary of the arrival of the hundreds of passengers from the Caribbean to the UK on the Empire Windrush. Eight Royal Mail stamps featuring original artworks by Black British artists were commissioned to celebrate the occasion, which will be revealed at the Black Cultural Archives in Brixton on Thursday.", comment: ""),
        image: "british_stamp",
        likes: 77,
        views: 263),
    
    Post(
        author: NSLocalizedString("Ryan Daws", comment: ""),
        description: NSLocalizedString("Google creates new AI division to challenge OpenAI. Google has consolidated its AI research labs, Google Brain and DeepMind, into a new unit named Google DeepMind. The new unit will be responsible for spearheading groundbreaking AI products and advancements, and it will work closely with other Google product areas to deliver AI research and products.", comment: ""),
        image: "tech",
        likes: 91,
        views: 512
    ),
    
    Post(
        author: NSLocalizedString("Urban Putt", comment: ""),
        description: NSLocalizedString("Do you enjoy your typical American food along with mini-golfing? If you come to Urban Putt, you can experience both at the same time! Urban Putt’s two locations in San Francisco and Denver feature an upscaled version of tasty American-fare food and cocktails that go perfectly with your meal. Then, once you’re done eating, you can enjoy a unique indoor mini-golf course that is perfect for everybody of all ages!", comment: ""),
        image: "golf_restaurant",
        likes: 34,
        views: 194
    ),
    
    Post(
        author: NSLocalizedString("Burning Man Festival", comment: ""),
        description: NSLocalizedString("Today, Burning Man is celebrated in the Nevada desert in late August and early September and now draws tens of thousands of participants. Black Rock City offers a venue for a wide range of participation and artistic expression, which can include pyrotechnics, performance art using light or fire, nude body painting, Mutant Vehicles and just about anything else that lends to the Burning Man experience.", comment: ""),
        image: "burning_man",
        likes: 102,
        views: 436
    ),
    
    Post(
        author: NSLocalizedString("Human", comment: ""),
        description: NSLocalizedString("Strategic design studio Human also put the ecstatic colours trend to good use in their designs for Casa Centinela, one of the most important tequila distilleries in Mexico. These can designs for the brand's RTD cocktails take inspiration from a bold vintage layout that represents the brand's heritage but with a twist in the colour palette representing Mexico's folklore and the vibrancy of the cocktail scene.", comment: ""),
        image: "design",
        likes: 34,
        views: 193
    ),
    
    Post(
        author: NSLocalizedString("György Palkó", comment: ""),
        description: NSLocalizedString("Architectural firm, Hello Wood – known for its unique cabin houses and builder festivals – has again designed a spectacular public installation. Placed in the centre of the Factory’ard in Veszprém, The Garden of Communities is an artwork that celebrates the rich culture of the Veszprém-Balaton region.", comment: ""),
        image: "garden",
        likes: 45,
        views: 332
    ),
    
    Post(
        author: NSLocalizedString("Art News", comment: ""),
        description: NSLocalizedString("Artists are important communicators in times of crisis. Art can connect the disconnected and find meaning in difficult times. The exhibition aims to give a platform for artists to invoke questions, dispel myths and forge a historical narrative of this unique time in history.", comment: ""),
        image: "gallery",
        likes: 67,
        views: 251
    )
]

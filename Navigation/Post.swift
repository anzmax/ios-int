import UIKit

struct Post {
    
    var author: String
    var description: String
    var image: String
    var likes: Int
    var views: Int
}


var posts: [Post] = [

    Post(
        author: "Royal Mail",
        description: "A special collection of stamps has been issued to mark the 75th anniversary of the arrival of the hundreds of passengers from the Caribbean to the UK on the Empire Windrush. Eight Royal Mail stamps featuring original artworks by Black British artists were commissioned to celebrate the occasion, which will be revealed at the Black Cultural Archives in Brixton on Thursday.",
        image: "british_stamp",
        likes: 77,
        views: 263),
    
    Post(
        author: "Ryan Daws",
        description: "Google creates new AI division to challenge OpenAI. Google has consolidated its AI research labs, Google Brain and DeepMind, into a new unit named Google DeepMind. The new unit will be responsible for spearheading groundbreaking AI products and advancements, and it will work closely with other Google product areas to deliver AI research and products.",
        image: "tech",
        likes: 91,
        views: 512
    ),
    
    Post(
        author: "Urban Putt",
        description: "Do you enjoy your typical American food along with mini-golfing? If you come to Urban Putt, you can experience both at the same time! Urban Putt’s two locations in San Francisco and Denver feature an upscaled version of tasty American-fare food and cocktails that go perfectly with your meal. Then, once you’re done eating, you can enjoy a unique indoor mini-golf course that is perfect for everybody of all ages!",
        image: "golf_restaurant",
        likes: 34,
        views: 194
    ),
    
    Post(
        author: "Burning Man Festival",
        description: "Today, Burning Man is celebrated in the Nevada desert in late August and early September and now draws tens of thousands of participants. Black Rock City offers a venue for a wide range of participation and artistic expression, which can include pyrotechnics, performance art using light or fire, nude body painting, Mutant Vehicles and just about anything else that lends to the Burning Man experience.",
        image: "burning_man",
        likes: 102,
        views: 436
    ),
    
    Post(
        author: "Human",
        description: "Strategic design studio Human also put the ecstatic colours trend to good use in their designs for Casa Centinela, one of the most important tequila distilleries in Mexico. These can designs for the brand's RTD cocktails take inspiration from a bold vintage layout that represents the brand's heritage but with a twist in the colour palette representing Mexico's folklore and the vibrancy of the cocktail scene.",
        image: "design",
        likes: 34,
        views: 193
    ),
    
    Post(
        author: "György Palkó",
        description: "Architectural firm, Hello Wood – known for its unique cabin houses and builder festivals – has again designed a spectacular public installation. Placed in the centre of the Factory’ard in Veszprém, The Garden of Communities is an artwork that celebrates the rich culture of the Veszprém-Balaton region.",
        image: "garden",
        likes: 45,
        views: 332
    ),
    
    Post(
        author: "Art News",
        description: "Artists are important communicators in times of crisis. Art can connect the disconnected and find meaning in difficult times. The exhibition aims to give a platform for artists to invoke questions, dispel myths and forge a historical narrative of this unique time in history.",
        image: "gallery",
        likes: 67,
        views: 251
    )
]

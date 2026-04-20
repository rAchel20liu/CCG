//
//  dish data.swift
//  CCG
//
//  Created by H2026215 on 2026/1/19.
//

import Foundation

struct DishInfo : Identifiable{
    let id = UUID()
    let dishname: String
    let description : String
    let ingredients : [Ingredient]
    let recipesteps : [RecipeStep]
}

struct Ingredient: Identifiable {
    let id = UUID()
    let name: String
    let unit: String
    let amountPerPerson: Double
}

struct RecipeStep: Identifiable {
    let id = UUID()
    let stepNumber: Int
    let title: String
    let description: String
    let timerDuration: Int?
}


struct DishData {
    static let beijingsoybeanpastenoodles = DishInfo(
        dishname: "Beijing Soy Bean Paste Noodles",
        description:"Beijing Soy Bean Paste Noodles is a iconic home-style dish from Beijing. It features chewy handmade noodles tossed with savory, thick soybean paste sauce (mixed with pork cubes) and fresh crunchy side dishes like cucumber or bean sprouts. Simple to make but rich in flavor, it’s a daily favorite for Beijingers and a must-try for anyone wanting to taste authentic Beijing cuisine.",
         ingredients: [
            Ingredient(name: "Handmade Noodles", unit: "g", amountPerPerson: 100),
            Ingredient(name: "Pork Belly", unit: "g", amountPerPerson: 50),
            Ingredient(name: "Yellow Soybean Paste", unit: "g", amountPerPerson: 25),
            Ingredient(name: "Sweet Bean Paste", unit: "g", amountPerPerson: 10),
            Ingredient(name: "Cooking Oil", unit: "ml", amountPerPerson: 15),
            Ingredient(name: "Cucumber", unit: "g", amountPerPerson: 50),
            Ingredient(name: "Carrot", unit: "g", amountPerPerson: 30),
            Ingredient(name: "Bean Sprouts", unit: "g", amountPerPerson: 40),
        ],
        recipesteps: [
            RecipeStep(stepNumber: 1, title: "Prepare Ingredients", description: "Cut pork belly into 0.5cm cubes.", timerDuration: nil ),
            RecipeStep(stepNumber: 1, title: "Prepare Ingredients", description: "Wash and shred cucumber and carrotrinse bean sprouts.", timerDuration: nil ),
            RecipeStep(stepNumber: 1, title: "Prepare Ingredients", description: "Mince ginger and garlic.", timerDuration: nil),
            RecipeStep(stepNumber: 1, title: "Prepare Ingredients", description: "Divide chopped scallions into two portions (one for frying the sauce, one for garnish).", timerDuration: nil ),
            RecipeStep(stepNumber: 2, title: "Fry the Zhajiang Sauce", description: "Pour the remaining cooking oil into the pan; when the oil is hot, add minced ginger and half the chopped scallions, stir-fry until fragrant; add pork belly cubes and stir-fry until the meat turns white and releases oil.", timerDuration: 120 ),
            RecipeStep(stepNumber: 2, title: "Fry the Zhajiang Sauce", description: "Add cooking wine to remove the porky smell, stir-fry for another 1 minute." , timerDuration: 60),
            RecipeStep(stepNumber: 2, title: "Fry the Zhajiang Sauce", description: "Add yellow soybean paste and sweet bean paste, stir well; add white sugar for seasoning." , timerDuration: nil),
            RecipeStep(stepNumber: 2, title: "Fry the Zhajiang Sauce", description: "Pour in a little water (just 1/3 of the sauce’s height); bring to a boil over high heat, then turn to low heat and simmer for 20 minute.", timerDuration: 1200 ),
            RecipeStep(stepNumber: 3, title: "Prepare Side Dishes", description: "Bring water to a boil in a pot and add bean sprouts and blanch for roughly 1 minute.", timerDuration: 60 ),
            RecipeStep(stepNumber: 3, title: "Prepare Side Dishes", description: "Rinse all shredded side dishes with cold water, then drain; arrange them on plates.", timerDuration: nil ),
            RecipeStep(stepNumber: 4, title: "Boil Noodles", description: "Add enough water to a pot; bring to a boil over high heat, then add handmade noodles; Boil noodles for 8-10 minutes until the noodles are soft without hard core.", timerDuration: 600 ),
            RecipeStep(stepNumber: 5, title: "Serve", description: "Place the boiled noodles at the bottom of a bowl, pour enough zhajiang sauce over them, add side dishes like shredded cucumber, carrot, bean sprouts, and egg skin, stir well and enjoy.", timerDuration: nil ),
        ]
        
    )
    
    static let pekingDuck = DishInfo(
        dishname: "Peking Duck",
        description: "Peking Duck is the most renowned dish from Beijing, celebrated worldwide for its crispy, golden-brown skin and tender, juicy meat. Traditionally roasted in a wood-fired oven (often with fruit wood like jujube or peach), it’s served with thin pancakes, sweet bean sauce, scallions, and cucumber sticks. The art of carving the duck tableside is a hallmark of this iconic dish, offering a perfect balance of textures and flavors.",
        ingredients: [
            Ingredient(name: "Peking Duck (Whole)", unit: "g", amountPerPerson: 300),
            Ingredient(name: "Wheat Pancakes", unit: "piece", amountPerPerson: 8),
            Ingredient(name: "Sweet Bean Sauce", unit: "g", amountPerPerson: 30),
            Ingredient(name: "Scallions (Green Part)", unit: "g", amountPerPerson: 20),
            Ingredient(name: "Cucumber (Strips)", unit: "g", amountPerPerson: 40),
            Ingredient(name: "Honey", unit: "ml", amountPerPerson: 10),
            Ingredient(name: "Vinegar", unit: "ml", amountPerPerson: 5),
            Ingredient(name: "Water", unit: "ml", amountPerPerson: 20),
            Ingredient(name: "Soy Sauce", unit: "ml", amountPerPerson: 8),
        ],
        recipesteps: [
            RecipeStep(stepNumber: 1, title: "Prepare the Duck", description: "Clean the whole duck, remove excess fat, and rinse thoroughly; pat dry with kitchen paper.", timerDuration: nil ),
            RecipeStep(stepNumber: 1, title: "Prepare the Duck", description: "Mix honey, vinegar, soy sauce and water to make a glaze; brush evenly over the duck skin." , timerDuration: nil),
            RecipeStep(stepNumber: 1, title: "Prepare the Duck", description: "Hang the duck in a well-ventilated area for 4-6 hours until the skin is completely dry (key for crispiness).", timerDuration: 21600 ),
            RecipeStep(stepNumber: 2, title: "Roast the Duck", description: "Preheat the oven to 200°C (392°F); place the duck on a roasting rack with a tray underneath to catch drippings." , timerDuration: nil),
            RecipeStep(stepNumber: 2, title: "Roast the Duck", description: "Roast for 30 minutes at 200°C, then lower the temperature to 180°C (356°F) and roast for another 40-50 minutes until the skin is golden and crispy." , timerDuration: 4800),
            RecipeStep(stepNumber: 2, title: "Roast the Duck", description: "For extra crispy skin, turn the oven to broil (grill) mode for the last 5 minutes (watch carefully to avoid burning).", timerDuration: 360 ),
            RecipeStep(stepNumber: 3, title: "Prepare Accompaniments", description: "Cut cucumber into thin strips and scallions into fine shreds; place in small dishes.", timerDuration: nil ),
            RecipeStep(stepNumber: 3, title: "Prepare Accompaniments", description: "Warm the wheat pancakes in a steamer for 2-3 minutes to make them soft and pliable.", timerDuration: 180 ),
            RecipeStep(stepNumber: 3, title: "Prepare Accompaniments", description: "Pour sweet bean sauce into a small bowl for serving.", timerDuration: nil ),
            RecipeStep(stepNumber: 4, title: "Carve and Serve", description: "Carve the roasted duck tableside: first slice the crispy skin into thin pieces, then slice the tender meat." , timerDuration: nil),
            RecipeStep(stepNumber: 4, title: "Carve and Serve", description: "To eat: spread sweet bean sauce on a pancake, add duck skin/meat, cucumber strips and scallions, roll up and enjoy." , timerDuration: nil),
        ]
    )

    // 葱爆肉丝（Shredded Pork with Scallions）
    static let shreddedPorkWithScallions = DishInfo(
        dishname: "Shredded Pork with Scallions",
        description: "Shredded Pork with Scallions is a classic and simple Beijing stir-fry, beloved for its bold, savory flavor and quick cooking time. It features tender pork shreds stir-fried with plenty of fresh scallions (spring onions), seasoned with soy sauce, rice wine, and a hint of sugar. The key is high heat and fast stir-frying to lock in the freshness of the scallions and keep the pork tender—an ideal weekday meal that pairs perfectly with steamed rice.",
        ingredients: [
            Ingredient(name: "Pork Tenderloin (Shredded)", unit: "g", amountPerPerson: 150),
            Ingredient(name: "Scallions (Spring Onions)", unit: "g", amountPerPerson: 100),
            Ingredient(name: "Cooking Wine", unit: "ml", amountPerPerson: 10),
            Ingredient(name: "Light Soy Sauce", unit: "ml", amountPerPerson: 15),
            Ingredient(name: "Dark Soy Sauce", unit: "ml", amountPerPerson: 5),
            Ingredient(name: "Cornstarch", unit: "g", amountPerPerson: 5),
            Ingredient(name: "Cooking Oil", unit: "ml", amountPerPerson: 20),
            Ingredient(name: "Ginger (Sliced)", unit: "g", amountPerPerson: 5),
            Ingredient(name: "Garlic (Sliced)", unit: "g", amountPerPerson: 5),
            Ingredient(name: "White Sugar", unit: "g", amountPerPerson: 2),
            Ingredient(name: "Salt", unit: "g", amountPerPerson: 1),
        ],
        recipesteps: [
            RecipeStep(stepNumber: 1, title: "Marinate the Pork", description: "Place shredded pork tenderloin in a bowl; add 5ml cooking wine, light soy sauce (5ml), cornstarch and a pinch of salt.", timerDuration: nil ),
            RecipeStep(stepNumber: 1, title: "Marinate the Pork", description: "Mix well and let marinate for 10 minutes to tenderize the meat.", timerDuration: 600 ),
            RecipeStep(stepNumber: 2, title: "Prepare Ingredients", description: "Cut scallions into 3cm long sections (separate white and green parts); slice ginger and garlic thinly." , timerDuration: nil),
            RecipeStep(stepNumber: 2, title: "Prepare Ingredients", description: "Mix remaining light soy sauce, dark soy sauce, cooking wine, sugar and a little water to make a sauce.", timerDuration: nil ),
            RecipeStep(stepNumber: 3, title: "Stir-Fry the Dish", description: "Heat a wok or pan over high heat; add cooking oil until smoking hot." , timerDuration: nil),
            RecipeStep(stepNumber: 3, title: "Stir-Fry the Dish", description: "Add marinated pork shreds and stir-fry quickly for 1-2 minutes until the meat changes color (do not overcook).", timerDuration: 120 ),
            RecipeStep(stepNumber: 3, title: "Stir-Fry the Dish", description: "Remove the pork from the pan and set aside (keep the oil in the pan).", timerDuration: nil ),
            RecipeStep(stepNumber: 3, title: "Stir-Fry the Dish", description: "In the same pan, add ginger and garlic, stir-fry for 10 seconds until fragrant; add the white parts of scallions and stir-fry for 30 seconds.", timerDuration: 10 ),
            RecipeStep(stepNumber: 3, title: "Stir-Fry the Dish", description: "Return the pork to the pan; pour in the prepared sauce and stir well for 30 seconds.", timerDuration: 30 ),
            RecipeStep(stepNumber: 3, title: "Stir-Fry the Dish", description: "Add the green parts of scallions, stir-fry for 10 more seconds to combine all flavors." , timerDuration: 15),
            RecipeStep(stepNumber: 4, title: "Serve", description: "Transfer to a plate immediately and serve hot with steamed rice or noodles." , timerDuration: nil),
        ]
    )
}






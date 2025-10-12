//
//  NewsListViewModel.swift
//  InfoNow
//
//  Created by Stefan kund on 12/10/2025.
//

import Foundation
import SwiftUI
internal import Combine

class NewsListViewModel: ObservableObject {
    
    @Published var newsList: [Article] = [
        Article(
            source: Source(id: nil, name: "20 Minutes"),
            author: "20 Minutes avec agences",
            title: "Lola Young porte plainte contre le producteur de son tube « Messy »",
            description: "Le producteur revendiquerait indûment les crédits d’écriture de quatre des titres de la chanteuse britannique",
            url: "https://www.20minutes.fr/arts-stars/people/4178338-20251011-lola-young-porte-plainte-contre-producteur-tube-messy",
            urlToImage: "https://img.20mn.fr/7yRX_nH4TVa_TXkGbhD90Sk/1444x920_celebrities-arrive-at-the-brit-awards-2025-at-intercontinental-hotel-london-featuring-lola-young-where-london-united-kingdom-when-01-mar-2025-credit-cover-images",
            publishedAt: "2025-10-12T16:40:00Z",
            content: "Lola Young ne se laissera pas flouer aussi facilement..."
        ),
        Article(
            source: Source(id: "le-monde", name: "Le Monde"),
            author: "Anne-Aël Durand",
            title: "Troubles du langage et de l’apprentissage : les prises en charge restent « insuffisantes »",
            description: "Dyslexie, dyspraxie, dyscalculie… Le diagnostic s’améliore...",
            url: "https://www.lemonde.fr/societe/article/2025/10/11/troubles-du-langage-et-de-l-apprentissage-les-prises-en-charge-restent-insuffisantes_6645763_3224.html",
            urlToImage: "https://img.lemde.fr/2025/10/10/0/0/6000/4000/1440/960/60/0/122e6dc_upload-1-27mb0fi6t05p-000-33u96e6.jpg",
            publishedAt: "2025-10-11T11:00:08Z",
            content: "Des lycéens, le jour de la rentrée scolaire, à Lyon..."
        ),
        Article(
            source: Source(id: "le-monde", name: "Le Monde"),
            author: "Le Monde",
            title: "EN DIRECT, Sébastien Lecornu, premier ministre...",
            description: "Renommé à Matignon vendredi soir...",
            url: "https://www.lemonde.fr/politique/live/2025/10/11/en-direct-sebastien-lecornu-premier-ministre-je-n-ai-pas-d-autre-ambition-que-de-sortir-de-ce-moment-qui-est-tres-penible-pour-tout-le-monde_6645554_823448.html",
            urlToImage: "https://img.lemde.fr/2025/10/11/119/0/2048/1024/1440/720/60/0/5ed2a6a_upload-1-ehnllythfexi-l1007136.jpg",
            publishedAt: "2025-10-11T10:51:28Z",
            content: "Horizons réunit de nouveau son bureau politique..."
        ),
        Article(
            source: Source(id: nil, name: "20 Minutes"),
            author: "20 Minutes avec AFP",
            title: "Trafic de stupéfiants : Huit personnes mises en examen, dont une avocate",
            description: "Les investigations ont mis à jour « un réseau organisé »...",
            url: "https://www.20minutes.fr/societe/4178680-20251011-trafic-stupefiants-huit-personnes-mises-examen-dont-avocate",
            urlToImage: "https://img.20mn.fr/SB84OCm5SCiOhifOjyv61yk/1444x920_illustration-d-agents-de-police-nationale-lors-d-une-operation-avec-la-population",
            publishedAt: "2025-10-11T10:35:10Z",
            content: "Un trafic international qui durait depuis le début..."
        ),
        Article(
            source: Source(id: nil, name: "20 Minutes"),
            author: "Caroline Vié",
            title: "« Super Grand prix » : Pourquoi Europa-Park se lance sur les circuits du cinéma",
            description: "Le parc d’attractions allemand produit un film d’animation...",
            url: "https://www.20minutes.fr/arts-stars/cinema/4177617-20251011-super-grand-prix-pourquoi-europa-park-lance-circuits-cinema",
            urlToImage: "https://img.20mn.fr/C--FvN3bRv-hUNNnfAtNvyk/1444x920_super-grand-prix-de-waldemar-fast",
            publishedAt: "2025-10-11T10:32:36Z",
            content: "Europa-Park se lance en cinéma ! Le parc dattractions allemand..."
        ),
        Article(
            source: Source(id: "le-monde", name: "Le Monde"),
            author: "Le Monde",
            title: "EN DIRECT, accord de paix à Gaza...",
            description: "Le plan Trump stipule qu’une « aide complète sera immédiatement acheminée... »",
            url: "https://www.lemonde.fr/international/live/2025/10/11/en-direct-accord-de-paix-a-gaza-les-organisations-humanitaires-optimistes-sur-retour-de-l-aide-mais-des-inquietudes-demeurent-sur-les-modalites_6645703_3210.html",
            urlToImage: "https://img.lemde.fr/2025/10/11/164/0/4671/2335/1440/720/60/0/7c6e1f8_ftp-import-images-1-9j57gmhis154-2025-10-11t084517z-1561625959-rc2k9hade4f9-rtrmadp-3-israel-palestinians-gaza.JPG",
            publishedAt: "2025-10-11T10:18:29Z",
            content: "Des personnes qui avaient été déplacées vers le sud..."
        )
    ]
    
    
    @Published var selectedArticle: Article? = nil
    @Published var associatedImage: Image? = nil
    
    

    public func selectArticle(article: Article, with image: Image?) {
        self.selectedArticle = article
        self.associatedImage = image
    }
    
}

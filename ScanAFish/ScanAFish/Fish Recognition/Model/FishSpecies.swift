//
//  FishSpecies.swift
//  FishScanner
//
//  Created by Németh Bendegúz on 2017. 08. 21..
//  Copyright © 2017. Németh Bendegúz. All rights reserved.
//

import Foundation

enum FishSpecies: String {
    case    apteronotus_albifrons,
    betta_splendens,
    carnegiella_strigata,
    celestichthys_margaritatus,
    chromobotia_macracanthus,
    corydoras_aeneus,
    corydoras_duplicareus,
    corydoras_paleatus,
    crossocheilus_oblongus,
    ctenopoma_acutirostre,
    goldfish,
    gymnocorymbus_ternetzi,
    hoplosternum_thoracatum,
    hyphessobrycon_amandae,
    hyphessobrycon_herbertaxelrodi,
    hyphessobrycon_megalopterus,
    hyphessobrycon_pulchripinnis,
    labeo_bicolor,
    labidochromis_caeruleus,
    melanochromis_cyaneorhabdos,
    melanotaenia_boesemani,
    mikrogeophagus_ramirezi,
    neolamprologus_buescheri_kamakonde,
    osteoglossum_bicirrhosum,
    paracheirodon_axelrodi,
    paracheirodon_innesi,
    pethia_conchonius,
    petitella_georgiae,
    poecilia_sphenops,
    puntigrus_tetrazona,
    rocio_octofasciata,
    synodontis_petricola,
    tanichthys_albonubes,
    tropheus_ikola,
    xiphophorus_helleri
    
}

extension FishSpecies {
    
    static var allCategory: [String] {
        return iterateEnum(FishSpecies.self).map { $0.rawValue.replacingOccurrences(of: "_", with: " ") }
    }
    
}

extension FishSpecies {
    
    static func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
        var i = 0
        return AnyIterator {
            let next = withUnsafeBytes(of: &i) { $0.load(as: T.self) }
            if next.hashValue != i { return nil }
            i += 1
            return next
        }
    }
    
}


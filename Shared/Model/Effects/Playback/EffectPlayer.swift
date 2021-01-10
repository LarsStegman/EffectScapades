//
//  EffectPlayer.swift
//  EffectScapades
//
//  Created by Lars Stegman on 01/01/2021.
//

import Foundation
import Combine

struct EffectStatus: Identifiable {
    var id: UUID
    var isPlaying: Bool
    var progress: Double
}

protocol EffectPlayerProtocol: ObservableObject {
    func status(of effect: UUID) -> EffectStatus

    func play(effect id: UUID)
    func stop(effect id: UUID)
}

extension EffectPlayerProtocol {
    func toggle(_ id: UUID) {
        if self.status(of: id).isPlaying {
            self.stop(effect: id)
        } else {
            self.play(effect: id)
        }
    }
}

class EffectPlayer<S: SoundRenderer>: EffectPlayerProtocol  {
    private var soundRenderers = [UUID: S]()
    private var renderObservers = Set<AnyCancellable>()
    private let soundRendererConstructor: () -> S

    let effectLibrary: AnyEffectLibrary

    init(soundRendererConstructor: @escaping () -> S, effectLibrary: AnyEffectLibrary) {
        self.soundRendererConstructor = soundRendererConstructor
        self.effectLibrary = effectLibrary
    }

    func status(of effect: UUID) -> EffectStatus {
        if let renderer = self.soundRenderers[effect] {
            return EffectStatus(id: effect, isPlaying: renderer.isPlaying, progress: renderer.progress)
        } else {
            return EffectStatus(id: effect, isPlaying: false, progress: 0.0)
        }
    }

    func play(effect id: UUID) {
        guard let effect = effectLibrary.effects[id] else {
            return
        }

        let renderer = soundRendererConstructor()
        soundRenderers[effect.id] = renderer
        let subscription = renderer.objectWillChange.sink { _ in self.objectWillChange.send() }
        renderObservers.update(with: subscription)

        effect.render(soundRenderer: renderer)
        renderer.play()
    }

    func stop(effect id: UUID) {
        guard let renderer = soundRenderers.removeValue(forKey: id) else {
            return
        }

        renderer.stop()
    }
}

extension EffectPlayer {
    func eraseToAnyEffectPlayer() -> AnyEffectPlayer {
        return AnyEffectPlayer(self)
    }
}

class AnyEffectPlayer: EffectPlayerProtocol {
    private var _status: (UUID) -> EffectStatus
    private var _play: (UUID) -> Void
    private var _stop: (UUID) -> Void

    private var _objectWillChange: ObservableObjectPublisher
    var objectWillChange: ObservableObjectPublisher {
        return _objectWillChange
    }

    init<E: EffectPlayerProtocol>(_ effectPlayer: E) where E.ObjectWillChangePublisher: ObservableObjectPublisher {
        _status = effectPlayer.status(of:)
        _play = effectPlayer.play
        _stop = effectPlayer.stop
        _objectWillChange = effectPlayer.objectWillChange
    }

    func status(of effect: UUID) -> EffectStatus {
        _status(effect)
    }

    func play(effect id: UUID) {
        _play(id)
    }

    func stop(effect id: UUID) {
        _stop(id)
    }
}

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
    var effects: [Effect] { get }
    var status: [UUID: EffectStatus] { get }

    func play(effect id: UUID)
    func stop(effect id: UUID)
}

class EffectPlayer<S: SoundRenderer>: EffectPlayerProtocol  {
    private var soundRenderers = [UUID: S]()
    private var renderObservers = Set<AnyCancellable>()
    private let soundRendererConstructor: () -> S

    @Published var effects: [Effect]
    var status: [UUID: EffectStatus] {
        return Dictionary(uniqueKeysWithValues: effects.compactMap { effect in
            let renderer = soundRenderers[effect.id]
            return (effect.id, EffectStatus(id: effect.id,
                                            isPlaying: renderer?.isPlaying ?? false,
                                            progress: renderer?.progress ?? 0.0))
        })
    }

    init(soundRendererConstructor: @escaping () -> S, effects: [Effect]) {
        self.soundRendererConstructor = soundRendererConstructor
        self.effects = effects
    }

    func play(effect id: UUID) {
        guard let effect = effects.first(where: { effect in effect.id == id }) else {
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
    private var _effectsGetter: () -> [Effect]
    private var _statusGetter: () -> [UUID: EffectStatus]
    private var _play: (UUID) -> Void
    private var _stop: (UUID) -> Void

    var effects: [Effect] {
        return _effectsGetter()
    }
    var status: [UUID: EffectStatus] {
        return _statusGetter()
    }

    private var _objectWillChange: ObservableObjectPublisher
    var objectWillChange: ObservableObjectPublisher {
        return _objectWillChange
    }

    init<E: EffectPlayerProtocol>(_ effectPlayer: E) where E.ObjectWillChangePublisher: ObservableObjectPublisher {
        _effectsGetter = { effectPlayer.effects }
        _statusGetter = { effectPlayer.status }
        _play = effectPlayer.play
        _stop = effectPlayer.stop
        _objectWillChange = effectPlayer.objectWillChange
    }

    func play(effect id: UUID) {
        _play(id)
    }

    func stop(effect id: UUID) {
        _stop(id)
    }
}

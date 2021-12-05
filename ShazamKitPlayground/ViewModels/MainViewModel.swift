//
//  MainViewModel.swift
//  ShazamKitDemo
//
//  Created by Tuğçe Arar on 5.12.2021.
//

import Foundation
import ShazamKit

class MainViewModel: NSObject,ObservableObject{
    @Published var shazamMedia = ShazamMedia(title:"Title",subTitle:"Subtitle",artistName:"Artist",albumArtURL:URL(string:"www.google.com"),genres:["Pop"])
    @Published var isRecording = false
    @Published var isBusy = true
    
    private let audioEngine = AVAudioEngine()
    private let session = SHSession()
    private let signatureGenerator = SHSignatureGenerator()
    
    override init() {
        super.init()
        session.delegate = self
    }
    
    func startOrEndListening(){
        guard !audioEngine.isRunning else {
            audioEngine.stop()
            DispatchQueue.main.async {
                self.isRecording = false
            }
            return
        }
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.requestRecordPermission { granted in
            guard granted else { return }
            try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            let inputNode = self.audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                self.session.matchStreamingBuffer(buffer, at: nil)
            }
            
            self.audioEngine.prepare()
            do{
                try self.audioEngine.start()
            } catch(let error)
            {
                assertionFailure(error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.isRecording = true
            }
        }
        
    }
    
}

extension MainViewModel : SHSessionDelegate{
    func session(_ session: SHSession, didFind match: SHMatch) {
        let mediaItems = match.mediaItems
        if let firstItem = mediaItems.first { 
            let _shazamMedia = ShazamMedia(title:firstItem.title,subTitle: firstItem.subtitle, artistName: firstItem.artist, albumArtURL: firstItem.artworkURL, genres: firstItem.genres)
            DispatchQueue.main.async{
                self.shazamMedia = _shazamMedia
            }
        }
    }
}

//
//  InputVoiceManager.swift
//  InputView
//
//  Created by V on 2023/6/12.
//

import UIKit
import Util_V
import AVFoundation

class InputVoiceManager: NSObject {
    
    let audioSetting: [String: Any] = [
        AVFormatIDKey: kAudioFormatMPEG4AAC,
        AVNumberOfChannelsKey: 1,
        AVSampleRateKey: 44100,
        AVEncoderBitRateKey: 64000
    ]
    
    //MARK: ----- writer --------
    private var url: URL!
    
    private var writer: AVAssetWriter!
    
    private var startTime: CMTime?
    
    private var audioWriterInput: AVAssetWriterInput!
    
    private let audioSemaphore = DispatchSemaphore(value: 1)
    private let audioQueue = DispatchQueue.global(qos: .userInteractive)
    
    private lazy var audioOutput: AVCaptureAudioDataOutput = {
        let output = AVCaptureAudioDataOutput()
        output.setSampleBufferDelegate(self, queue: audioQueue)
        return output
    }()
    
    //MARK: ------ Session ---------
    private(set) lazy var session: AVCaptureSession = {
        let session = AVCaptureSession()
        session.beginConfiguration()
        do {
            if let device = AVCaptureDevice.default(for: .audio) {
                let audioInput = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(audioInput) {
                    session.addInput(audioInput)
                }
            }
        } catch {
            debugPrint(error)
        }
        session.commitConfiguration()
        return session
    }()
    
    
}

extension InputVoiceManager {
    func starCapture() {
        startTime = nil
        url = (UUID().uuidString + ".acc").createFile!
        
        do {
            writer = try AVAssetWriter(url: url, fileType: .mov)
            audioWriterInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioSetting)
            audioWriterInput.expectsMediaDataInRealTime = true
            if writer.canAdd(audioWriterInput) {
                writer.add(audioWriterInput)
            }
            
            self.writer.startWriting()
            if !session.isRunning {
                session.startRunning()
            }
        } catch {
            debugPrint(error)
        }
    }
    
    func stopCapture(complet: @escaping ((_ url: URL)->())) {
        if session.isRunning {
            session.stopRunning()
        }
        
        self.audioWriterInput.markAsFinished()
        self.writer.finishWriting {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                complet(self.url)
            }
        }
    }
}

extension InputVoiceManager: AVCaptureAudioDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if !session.isRunning {
            return
        }
        
        if let writer = self.writer,
            writer.status == .writing {
            
            encodeAudioReadySampleBuffer(didOutput: sampleBuffer)
        }
    }
    
    private func encodeAudioReadySampleBuffer(didOutput sampleBuffer: CMSampleBuffer) {
        
        guard let input = audioWriterInput else {
            return
        }
        
        if audioSemaphore.wait(timeout: .now()) != .success {
            debugPrint("音频丢帧")
            return
        }
        
        if startTime == nil {
            audioQueue.sync {
                let time = CMSampleBufferGetOutputPresentationTimeStamp(sampleBuffer)
                self.writer.startSession(atSourceTime: time)
                self.startTime = time
            }
        }
        
        //等待input空闲
        while !input.isReadyForMoreMediaData {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.5))
        }
        
        if input.isReadyForMoreMediaData {
            input.append(sampleBuffer)
        } else {
            debugPrint("音频丢帧")
        }
        
        audioSemaphore.signal()
    }
}

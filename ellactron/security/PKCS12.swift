import Foundation

public class PKCS12  {
    var label:String?
    var keyID:Data?
    var trust:SecTrust?
    var certChain:[SecTrust]?
    var identity:SecIdentity?
    
    
    var secCertificatesRef: [SecCertificate] = []
    
    let importResult:OSStatus
    
    init(data:Data, password:String) {
        var imported:CFArray?
        let certOptions:NSDictionary = [kSecImportExportPassphrase as NSString:password as NSString]
        
        // import certificate to read its entries
        self.importResult = SecPKCS12Import(data as NSData, certOptions, &imported);
        
        if importResult == errSecSuccess {
            //let count = CFArrayGetCount(imported);
            //for i in 0...count-1 {
                let identityDict = unsafeBitCast(CFArrayGetValueAtIndex(imported!, 0), to: CFDictionary.self) as NSDictionary
                
                self.label = identityDict[kSecImportItemLabel as String] as? String;
                self.keyID = identityDict[kSecImportItemKeyID as String] as? Data;
                self.trust = identityDict[kSecImportItemTrust as String] as! SecTrust?;
                self.certChain = identityDict[kSecImportItemCertChain as String] as? Array<SecTrust>;
                self.identity = identityDict[kSecImportItemIdentity as String] as! SecIdentity?
                
                var certRef: SecCertificate?
                switch SecIdentityCopyCertificate(self.identity!, &certRef) {
                case noErr:
                    self.secCertificatesRef.append(certRef!)
                case errSecAuthFailed:
                    NSLog("SecIdentityCopyCertificate - errSecAuthFailed: Authorization/Authentication failed.")
                default:
                    NSLog("SecIdentityCopyCertificate - Unknown OSStatus error")
                }
            //}
        }
    }
    
    public convenience init(mainBundleResource:String, resourceType:String, password:String) {
        self.init(data: NSData(contentsOfFile: Bundle.main.path(forResource: mainBundleResource, ofType:resourceType)!)! as Data, password: password);
    }
    
    public func urlCredential()  -> URLCredential  {
        return URLCredential(
            identity: self.identity!,
            certificates: self.certChain!,
            persistence: URLCredential.Persistence.forSession);
        
    }
}

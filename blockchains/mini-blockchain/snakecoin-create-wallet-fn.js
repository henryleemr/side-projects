function createWallet(){
  let privateKey = createPrivateKey();
  let publicKey  = getPublicKey(privateKey);
  let address    = createAddress(publicKey);
  return ({
    private: privateKey.toString('hex'),
    public: publicKey.toString('hex'),
    address: address
  });
}
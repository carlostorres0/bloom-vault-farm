# Vercel Deployment Guide for Bloom Vault Farm

This guide provides step-by-step instructions for deploying the Bloom Vault Farm application to Vercel.

## Prerequisites

- GitHub account
- Vercel account (free tier available)
- Node.js installed locally (for testing)

## Step 1: Prepare the Repository

1. **Fork or Clone the Repository**
   ```bash
   git clone https://github.com/carlostorres0/bloom-vault-farm.git
   cd bloom-vault-farm
   ```

2. **Install Dependencies**
   ```bash
   npm install
   ```

3. **Test Locally**
   ```bash
   npm run dev
   ```
   Visit `http://localhost:8080` to verify the application works.

## Step 2: Create Vercel Account and Connect GitHub

1. **Sign up for Vercel**
   - Go to [vercel.com](https://vercel.com)
   - Click "Sign up" and choose "Continue with GitHub"
   - Authorize Vercel to access your GitHub repositories

2. **Import Project**
   - In Vercel dashboard, click "New Project"
   - Select "Import Git Repository"
   - Choose `carlostorres0/bloom-vault-farm` from the list
   - Click "Import"

## Step 3: Configure Build Settings

1. **Framework Preset**
   - Framework Preset: `Vite`
   - Build Command: `npm run build`
   - Output Directory: `dist`
   - Install Command: `npm install`

2. **Root Directory**
   - Leave empty (project is in root)

## Step 4: Configure Environment Variables

In the Vercel dashboard, go to your project settings and add these environment variables:

### Required Environment Variables

```env
# Chain Configuration
NEXT_PUBLIC_CHAIN_ID=11155111
NEXT_PUBLIC_RPC_URL=https://sepolia.infura.io/v3/YOUR_INFURA_KEY

# Wallet Connect Configuration
NEXT_PUBLIC_WALLET_CONNECT_PROJECT_ID=YOUR_WALLET_CONNECT_PROJECT_ID

# Infura Configuration (Optional)
NEXT_PUBLIC_INFURA_API_KEY=YOUR_INFURA_API_KEY
NEXT_PUBLIC_RPC_URL=https://1rpc.io/sepolia
```

### How to Add Environment Variables in Vercel:

1. Go to your project dashboard
2. Click on "Settings" tab
3. Click on "Environment Variables" in the left sidebar
4. Add each variable:
   - **Name**: `NEXT_PUBLIC_CHAIN_ID`
   - **Value**: `11155111`
   - **Environment**: Production, Preview, Development
   - Click "Save"

5. Repeat for all environment variables listed above.

## Step 5: Deploy the Application

1. **Automatic Deployment**
   - After configuring environment variables, Vercel will automatically deploy
   - You can also trigger a manual deployment by clicking "Deploy" button

2. **Monitor Deployment**
   - Watch the build logs in the Vercel dashboard
   - Ensure all environment variables are properly set
   - Check for any build errors

## Step 6: Configure Custom Domain (Optional)

1. **Add Custom Domain**
   - Go to your project settings
   - Click on "Domains" tab
   - Add your custom domain
   - Follow DNS configuration instructions

2. **SSL Certificate**
   - Vercel automatically provides SSL certificates
   - HTTPS will be enabled automatically

## Step 7: Verify Deployment

1. **Test the Application**
   - Visit your Vercel deployment URL
   - Test wallet connection functionality
   - Verify all pages load correctly
   - Check that environment variables are working

2. **Test Wallet Integration**
   - Connect with MetaMask or Rainbow wallet
   - Ensure you're on Sepolia testnet
   - Test wallet switching functionality

## Step 8: Production Optimizations

1. **Performance Monitoring**
   - Enable Vercel Analytics (optional)
   - Monitor Core Web Vitals
   - Check bundle size optimization

2. **Security Headers**
   - Vercel automatically adds security headers
   - Consider adding Content Security Policy if needed

## Troubleshooting

### Common Issues:

1. **Build Failures**
   - Check environment variables are set correctly
   - Verify all dependencies are in package.json
   - Check build logs for specific errors

2. **Wallet Connection Issues**
   - Ensure WalletConnect Project ID is correct
   - Verify RPC URLs are accessible
   - Check network configuration

3. **Environment Variable Issues**
   - Ensure all variables start with `NEXT_PUBLIC_`
   - Check variable names match exactly
   - Verify values are correct

### Build Logs Location:
- Vercel Dashboard → Your Project → Deployments → Click on deployment → View Function Logs

## Deployment Checklist

- [ ] Repository cloned and tested locally
- [ ] Vercel account created and GitHub connected
- [ ] Project imported to Vercel
- [ ] Build settings configured (Vite preset)
- [ ] All environment variables added
- [ ] Initial deployment successful
- [ ] Wallet connection tested
- [ ] All pages accessible
- [ ] Custom domain configured (if applicable)

## Support

For issues with:
- **Vercel Deployment**: Check [Vercel Documentation](https://vercel.com/docs)
- **Wallet Integration**: Check [RainbowKit Documentation](https://www.rainbowkit.com/docs/introduction)
- **FHE Contracts**: Check [FHEVM Documentation](https://docs.fhevm.org/)

## Next Steps After Deployment

1. **Smart Contract Deployment**
   - Deploy FHE contracts to Sepolia testnet
   - Update contract addresses in frontend
   - Test contract interactions

2. **Production Environment**
   - Set up monitoring and logging
   - Configure backup strategies
   - Plan for scaling

3. **User Testing**
   - Conduct user acceptance testing
   - Gather feedback and iterate
   - Plan feature enhancements

const path = require('path');
const webpack = require('webpack');
const fs = require('fs-extra');

const mainConfig = {
    mode: 'development',
    target: 'electron-main',
    entry: path.resolve(__dirname, '../src/main/index.js'),
    output: {
        path: path.resolve(__dirname, '../dist/main'),
        filename: 'main.js'
    },
    module: {
        rules: [
            {
                test: /\.jsx?$/,
                exclude: /node_modules/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        presets: ['@babel/preset-env', '@babel/preset-react'],
                        plugins: [
                            '@babel/plugin-proposal-object-rest-spread',
                            '@babel/plugin-syntax-dynamic-import',
                            '@babel/plugin-transform-async-to-generator'
                        ]
                    }
                }
            },
            {
                test: /\.json$/,
                type: 'javascript/auto',
                use: 'json-loader'
            }
        ]
    },
    resolve: {
        extensions: ['.js', '.jsx', '.json']
    },
    externals: {
        'electron': 'commonjs electron'
    },
    node: {
        __dirname: false,
        __filename: false
    }
};

// Ensure dist/main directory exists
fs.ensureDirSync(path.resolve(__dirname, '../dist/main'));

webpack(mainConfig, (err, stats) => {
    if (err) {
        console.error(err);
        process.exit(1);
    }
    
    if (stats.hasErrors()) {
        console.error(stats.toString({ colors: true }));
        process.exit(1);
    }
    
    console.log(stats.toString({ colors: true }));
    console.log('Main process compiled successfully!');
});

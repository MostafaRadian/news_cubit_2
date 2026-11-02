import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/news_model.dart';

class ArticleWebViewScreen extends StatefulWidget {
  final Article article;

  const ArticleWebViewScreen({required this.article, super.key});

  @override
  State<ArticleWebViewScreen> createState() => _ArticleWebViewScreenState();
}

class _ArticleWebViewScreenState extends State<ArticleWebViewScreen> {
  WebViewController? _controller;
  late final Uri? _articleUri;
  int _progress = 0;
  bool _hasError = false;

  bool get _supportsEmbeddedWebView =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  bool get _isLoading =>
      _supportsEmbeddedWebView && !_hasError && _progress < 100;

  @override
  void initState() {
    super.initState();

    final parsedUri = Uri.tryParse(widget.article.url);
    _articleUri =
        parsedUri != null &&
            (parsedUri.scheme == 'https' || parsedUri.scheme == 'http') &&
            parsedUri.host.isNotEmpty
        ? parsedUri
        : null;

    if (_articleUri == null) {
      _hasError = true;
      return;
    }

    if (!_supportsEmbeddedWebView) return;

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (mounted) setState(() => _progress = progress);
          },
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() {
              _hasError = false;
              _progress = 0;
            });
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _progress = 100);
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame == false || !mounted) return;
            setState(() => _hasError = true);
          },
          onNavigationRequest: (request) {
            final uri = Uri.tryParse(request.url);
            if (uri == null ||
                (uri.scheme != 'https' && uri.scheme != 'http')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );

    _controller!.loadRequest(_articleUri);
  }

  Future<void> _reload() async {
    if (!_supportsEmbeddedWebView) {
      await _openInBrowser();
      return;
    }
    if (_articleUri == null || _controller == null) return;
    setState(() {
      _hasError = false;
      _progress = 0;
    });
    await _controller!.loadRequest(_articleUri);
  }

  Future<void> _openInBrowser() async {
    final uri = _articleUri;
    if (uri == null) return;

    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the publisher website.')),
      );
    }
  }

  Widget _buildDesktopFallback() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.open_in_browser_rounded,
              size: 42,
              color: Color(0xFFB6A1FF),
            ),
            const SizedBox(height: 14),
            const Text(
              'Continue reading in your browser',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'This desktop platform does not support an embedded browser yet.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF92949D)),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: _articleUri == null ? null : _openInBrowser,
              icon: const Icon(Icons.open_in_new_rounded),
              label: const Text('Open publisher website'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final publisher = widget.article.source.trim();

    return Scaffold(
      appBar: AppBar(
        title: Text(publisher.isEmpty ? 'Article' : publisher),
        actions: [
          IconButton(
            tooltip: _supportsEmbeddedWebView
                ? 'Reload article'
                : 'Open in browser',
            onPressed: _reload,
            icon: Icon(
              _supportsEmbeddedWebView
                  ? Icons.refresh_rounded
                  : Icons.open_in_new_rounded,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isLoading)
            LinearProgressIndicator(
              value: _progress == 0 ? null : _progress / 100,
              minHeight: 2,
            )
          else
            const SizedBox(height: 2),
          Expanded(
            child: !_supportsEmbeddedWebView
                ? _buildDesktopFallback()
                : _hasError
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.language_rounded,
                            size: 38,
                            color: Color(0xFF7A807D),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'This article couldn’t be opened',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'The publisher may be temporarily unavailable.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xFF92949D)),
                          ),
                          const SizedBox(height: 12),
                          TextButton.icon(
                            onPressed: _reload,
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Try again'),
                          ),
                        ],
                      ),
                    ),
                  )
                : WebViewWidget(controller: _controller!),
          ),
        ],
      ),
    );
  }
}

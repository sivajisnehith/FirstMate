import React, { useState } from 'react';
import Markdown from 'react-markdown';
import { Loader2, Copy, Check } from 'lucide-react';

const mockMarkdown = `
## Features
* **AI Duplicate Engine:** Improved detection accuracy by 15%.
* **Dark Mode Strategy:** Applied new sophisticated dark theme across all views.
* **PR Analytics:** Added new visualizations for stalled Pull Requests.

## Bug Fixes
* Fixed an issue where the sidebar would collapse incorrectly on smaller screens.
* Corrected color contrast ratios for accessibility in the active PR table.
* Prevented memory leak when rapidly switching between tabs.

## Contributors
* @flutter-dev-1
* @firstmate-bot
* @open-source-contributor
`;

export default function ReleaseNotesView() {
  const [version, setVersion] = useState('v1.3.0');
  const [loading, setLoading] = useState(false);
  const [notesGenerated, setNotesGenerated] = useState(false);
  const [copied, setCopied] = useState(false);

  const handleGenerate = () => {
    setLoading(true);
    setNotesGenerated(false);
    setTimeout(() => {
      setLoading(false);
      setNotesGenerated(true);
    }, 2000);
  };

  const handleCopy = () => {
    navigator.clipboard.writeText(mockMarkdown);
    setCopied(true);
    setTimeout(() => setCopied(false), 3000);
  };

  return (
    <div className="flex flex-col h-full relative space-y-4">
      {/* Header matching GitHub box headers */}
      <div className="bg-[#161b22] border border-[#30363d] rounded-t-md p-4 flex items-center justify-between">
        <span className="font-semibold text-white text-sm">Release Notes Generator</span>
      </div>

      <div className="bg-[#0d1117] border border-t-0 border-[#30363d] rounded-b-md p-6 -mt-4 text-[#c9d1d9]">
        <div className="flex flex-col sm:flex-row sm:items-end gap-4">
          <div className="flex flex-col space-y-2 flex-1">
            <label className="text-sm font-semibold text-[#c9d1d9]">Target Version Tag</label>
            <div className="relative">
              <select 
                value={version}
                onChange={(e) => setVersion(e.target.value)}
                className="w-full appearance-none bg-[#0d1117] border border-[#30363d] text-[#c9d1d9] text-sm rounded-md pr-10 pl-3 py-1.5 focus:outline-none focus:border-[#58a6ff] focus:ring-1 focus:ring-[#58a6ff] transition-colors"
                style={{ WebkitAppearance: 'none', MozAppearance: 'none' }}
              >
                <option value="v1.2.3">v1.2.3</option>
                <option value="v1.3.0">v1.3.0</option>
              </select>
              <div className="pointer-events-none absolute inset-y-0 right-0 flex items-center px-3 text-[#8b949e]">
                <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 9l-7 7-7-7"></path></svg>
              </div>
            </div>
          </div>
          <button 
            onClick={handleGenerate}
            disabled={loading}
            className="bg-[#238636] hover:bg-[#2ea043] text-white text-sm font-medium py-1.5 px-4 rounded-md transition-colors flex items-center justify-center disabled:opacity-50 disabled:cursor-not-allowed border border-[rgba(240,246,252,0.1)] shrink-0"
          >
            {loading ? (
              <>
                <Loader2 className="w-4 h-4 mr-2 animate-spin" />
                Analyzing...
              </>
            ) : (
              'Generate Notes'
            )}
          </button>
        </div>
        
        {loading && (
          <div className="mt-8 flex flex-col items-center justify-center text-[#8b949e] py-12">
            <Loader2 className="w-8 h-8 mb-4 animate-spin text-[#58a6ff]" />
            <p className="text-sm">Claude analyzing merged PRs...</p>
          </div>
        )}
      </div>

      {notesGenerated && !loading && (
        <div className="bg-[#0d1117] border border-[#30363d] rounded-md overflow-hidden relative">
           <div className="bg-[#161b22] border-b border-[#30363d] p-3 flex justify-between items-center text-sm font-semibold text-[#c9d1d9]">
             Preview
             <button 
               onClick={handleCopy}
               className="p-1.5 bg-[#21262d] border border-[#f0f6fc1a] text-[#c9d1d9] rounded-md hover:bg-[#30363d] hover:border-[#8b949e] transition-colors"
               title="Copy Markdown"
             >
               {copied ? <Check className="w-4 h-4 text-[#3fb950]" /> : <Copy className="w-4 h-4" />}
             </button>
           </div>
           <div className="p-6">
            <div className="[&>h2]:text-[1.5em] [&>h2]:font-semibold [&>h2]:text-[#c9d1d9] [&>h2]:mt-6 [&>h2]:mb-4 [&>h2]:border-b [&>h2]:border-[#21262d] [&>h2]:pb-2 [&>h2:first-child]:mt-0 [&>ul]:list-disc [&>ul]:ml-6 [&>ul]:mb-4 [&>ul>li]:text-[#c9d1d9] [&>ul>li]:mb-1 [&>ul>li>strong]:text-white [&>ul>li>strong]:font-semibold">
              <Markdown>{mockMarkdown}</Markdown>
            </div>
           </div>
        </div>
      )}

      {/* Snackbar / Toast */}
      <div 
        className={`fixed bottom-6 right-6 bg-[#238636] text-white text-sm py-3 px-4 rounded-md shadow-lg border border-[rgba(240,246,252,0.1)] transition-all duration-300 ${copied ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8 pointer-events-none'}`}
      >
        <div className="flex items-center gap-2">
          <Check className="w-4 h-4" />
          Markdown copied to clipboard!
        </div>
      </div>
    </div>
  );
}

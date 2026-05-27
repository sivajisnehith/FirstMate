/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import React, { useState } from 'react';
import { duplicateIssues, prStatuses } from './mockData';
import { GitPullRequest, Copy, CheckCircle2, CircleDashed, AlertCircle, ExternalLink, Activity, Ship } from 'lucide-react';
import ReleaseNotesView from './components/ReleaseNotesView';

export default function App() {
  const [activeTab, setActiveTab] = useState('duplicates');

  return (
    <div className="w-full h-screen bg-[#0d1117] text-[#c9d1d9] flex font-sans selection:bg-[#388bfd]/30 selection:text-white">
      {/* Left Navigation Rail */}
      <nav className="w-64 bg-[#010409] border-r border-[#30363d] flex flex-col justify-between py-6 shrink-0">
        <div className="flex flex-col w-full">
          <div className="px-6 mb-8 flex items-center space-x-3 text-white">
            <div className="w-8 h-8 bg-[#161b22] border border-[#30363d] p-1.5 rounded-lg flex items-center justify-center">
               <Ship className="w-full h-full text-[#c9d1d9]" />
            </div>
            <span className="font-semibold tracking-tight">FirstMate</span>
          </div>
          
          <div className="flex flex-col space-y-1 px-3">
            <div className="px-3 mb-2 text-xs font-medium text-[#c9d1d9]">Triage</div>
            <button 
              onClick={() => setActiveTab('duplicates')}
              className={`flex items-center w-full px-3 py-2 rounded-md transition-colors text-sm ${activeTab === 'duplicates' ? 'bg-[#161b22] text-white' : 'text-[#8b949e] hover:bg-[#161b22] hover:text-[#c9d1d9]'}`}
            >
              <AlertCircle className="w-4 h-4 mr-3" />
              Duplicates
            </button>
            <button 
              onClick={() => setActiveTab('pr_status')}
              className={`flex items-center w-full px-3 py-2 rounded-md transition-colors text-sm ${activeTab === 'pr_status' ? 'bg-[#161b22] text-white' : 'text-[#8b949e] hover:bg-[#161b22] hover:text-[#c9d1d9]'}`}
            >
              <GitPullRequest className="w-4 h-4 mr-3" />
              Pull Requests
            </button>
            <button 
              onClick={() => setActiveTab('release')}
              className={`flex items-center w-full px-3 py-2 rounded-md transition-colors text-sm ${activeTab === 'release' ? 'bg-[#161b22] text-white' : 'text-[#8b949e] hover:bg-[#161b22] hover:text-[#c9d1d9]'}`}
            >
              <Activity className="w-4 h-4 mr-3" />
              Release Notes
            </button>
          </div>
        </div>
        <div className="px-6">
          <div className="flex items-center space-x-2 text-xs text-[#8b949e]">
            <div className="w-2 h-2 rounded-full bg-[#238636]" />
            <span>flutter/flutter</span>
          </div>
        </div>
      </nav>

      {/* Main Content Area */}
      <main className="flex-1 flex flex-col h-full overflow-hidden">
        {/* Header */}
        <header className="h-16 border-b border-[#30363d] flex items-center px-8 shrink-0 bg-[#010409]">
          <h1 className="text-sm font-medium text-white">
            {activeTab === 'duplicates' && 'Issue Triage'}
            {activeTab === 'pr_status' && 'Pull Request Health'}
            {activeTab === 'release' && 'Release Notes'}
          </h1>
        </header>

        {/* Dashboard Content */}
        <div className="flex-1 p-8 overflow-y-auto">
          <div className="max-w-[1216px] mx-auto">
          {activeTab === 'duplicates' && (
            <div className="space-y-4">
              {/* GitHub Issue List Header */}
              <div className="bg-[#161b22] border border-[#30363d] rounded-t-md p-4 flex items-center gap-4">
                <AlertCircle className="w-5 h-5 text-[#c9d1d9]" />
                <span className="font-semibold text-white">{duplicateIssues.length} Duplicate Issues</span>
              </div>
              
              <div className="bg-[#0d1117] border border-t-0 border-[#30363d] rounded-b-md -mt-4 divide-y divide-[#30363d]">
                {duplicateIssues.map((issue, idx) => (
                  <div key={idx} className="p-4 flex gap-3 hover:bg-[#161b22] transition-colors">
                    <div className="mt-1">
                      <AlertCircle className="w-5 h-5 text-[#238636]" />
                    </div>
                    <div className="flex-1">
                      <div className="flex items-center gap-2 mb-1 cursor-pointer">
                        <h3 className="text-white font-semibold text-base hover:text-[#58a6ff]">{issue.duplicate_title}</h3>
                        <span className={`px-2 py-0.5 rounded-full border text-xs font-medium ${
                          issue.confidence >= 0.9 
                            ? 'border-[#8957e5] text-[#8957e5]' 
                            : 'border-[#30363d] text-[#8b949e]'
                          }`}>
                          duplicate {Math.round(issue.confidence * 100)}%
                        </span>
                      </div>
                      <div className="text-xs text-[#8b949e]">
                        #{issue.duplicate_issue} opened as duplicate of <span className="text-[#c9d1d9] font-medium hover:text-[#58a6ff] cursor-pointer">#{issue.master_issue}</span> ({issue.master_title})
                      </div>
                      <div className="mt-2 text-sm text-[#8b949e] break-words whitespace-normal max-w-full">
                        {issue.reason}
                      </div>
                    </div>
                    <div className="flex items-start gap-2 shrink-0">
                       <button className="px-3 py-1 bg-[#21262d] border border-[#f0f6fc1a] text-[#c9d1d9] text-xs font-medium rounded-md hover:bg-[#30363d] hover:border-[#8b949e] transition-colors">
                         Compare
                       </button>
                       <button className="px-3 py-1 bg-[#21262d] border border-[#f0f6fc1a] text-[#f85149] text-xs font-medium rounded-md hover:bg-[#f85149] hover:text-white transition-colors">
                         Close with comment
                       </button>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}

          {activeTab === 'pr_status' && (
            <div className="space-y-4">
              <div className="bg-[#161b22] border border-[#30363d] rounded-t-md p-4 flex items-center gap-4">
                <GitPullRequest className="w-5 h-5 text-[#c9d1d9]" />
                <span className="font-semibold text-white">{prStatuses.length} Pull requests</span>
              </div>
              
              <div className="bg-[#0d1117] border border-t-0 border-[#30363d] rounded-b-md -mt-4 p-2 space-y-1">
                {prStatuses.sort((a,b) => b.daysOld - a.daysOld).map((pr, idx) => {
                  let IconComponent = GitPullRequest;
                  let iconColor = "text-[#238636]"; // GitHub green PR icon
                  let labelText = "Open";
                  let labelColor = "text-[#c9d1d9] border-[#30363d]";

                  if (pr.status === 'STALLED') {
                    if (pr.daysOld >= 14) {
                      labelText = "Stalled (14d+)";
                      labelColor = "text-[#f85149] border-[#f85149]";
                    } else {
                      labelText = "Needs review";
                      labelColor = "text-[#d29922] border-[#d29922]";
                    }
                  } else {
                     labelText = "Active";
                     labelColor = "text-[#238636] border-[#238636]";
                  }

                  return (
                    <div key={idx} className="p-3 flex gap-3 hover:bg-[#1c2128] hover:shadow-lg hover:-translate-y-0.5 transform rounded-md transition-all duration-200 border border-transparent hover:border-[#424a53]">
                      <div className="mt-1">
                        <IconComponent className={`w-5 h-5 ${iconColor}`} />
                      </div>
                      <div className="flex-1">
                        <div className="flex items-center gap-2 mb-1 cursor-pointer">
                          <h3 className="text-white font-semibold text-base hover:text-[#58a6ff]">{pr.title}</h3>
                          <span className={`px-2 py-0.5 rounded-full border text-xs font-medium ${labelColor}`}>
                            {labelText}
                          </span>
                        </div>
                        <div className="text-xs text-[#8b949e]">
                          #{pr.number} opened {pr.daysOld} days ago
                        </div>
                      </div>
                      <div className="flex items-start shrink-0">
                         <button className="px-3 py-1 bg-[#21262d] border border-[#f0f6fc1a] text-[#c9d1d9] text-xs font-medium rounded-md hover:bg-[#30363d] hover:border-[#8b949e] transition-colors">
                           Review
                         </button>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          )}

          {activeTab === 'release' && (
             <ReleaseNotesView />
          )}
          </div>
        </div>
      </main>
    </div>
  );
}


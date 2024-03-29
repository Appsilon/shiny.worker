% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/worker.R
\name{Worker}
\alias{Worker}
\title{Shiny Worker R6 Class}
\description{
Shiny Worker R6 Class

Shiny Worker R6 Class
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-Worker-new}{\code{Worker$new()}}
\item \href{#method-Worker-run_job}{\code{Worker$run_job()}}
\item \href{#method-Worker-get_job_registry}{\code{Worker$get_job_registry()}}
\item \href{#method-Worker-clone}{\code{Worker$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Worker-new"></a>}}
\if{latex}{\out{\hypertarget{method-Worker-new}{}}}
\subsection{Method \code{new()}}{
Initialize the worker's registry
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Worker$new()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Worker-run_job"></a>}}
\if{latex}{\out{\hypertarget{method-Worker-run_job}{}}}
\subsection{Method \code{run_job()}}{
Add job to the registry
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Worker$run_job(
  id,
  fun,
  args_reactive,
  value_until_resolved = NULL,
  invalidate_time = 1000
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{id}}{character with job id}

\item{\code{fun}}{function to calculate}

\item{\code{args_reactive}}{reactive arguments that trigger the job}

\item{\code{value_until_resolved}}{default value returned until the job is completed}

\item{\code{invalidate_time}}{wait time before invalidating reactive context (msec)}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
reactive expression with promise of job completion
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Worker-get_job_registry"></a>}}
\if{latex}{\out{\hypertarget{method-Worker-get_job_registry}{}}}
\subsection{Method \code{get_job_registry()}}{
Displays jobs registry.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Worker$get_job_registry()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Worker-clone"></a>}}
\if{latex}{\out{\hypertarget{method-Worker-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Worker$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}

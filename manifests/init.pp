include devusr

class jslave (
    $jmaster = "http://your.server/jenkins"
){

    $username  = $devusr::username
    $usergroup = $devusr::usergroup

    $swarmurl = "http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client"
    $swarmversion = "1.16"

    #Default Path
    $defpath   = "/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin"

    exec { 'fetch-swarmjar': 
        command => "curl -o /home/$username/swarm.jar ${swarmurl}/${swarmversion}/swarm-client-${swarmversion}-jar-with-dependencies.jar",
        user    => $username,
        cwd     => "/home/$username",
        path    => $defpath,
        unless  => "ls /home/$username/swarm.jar",
        require => User['devusr']
    }

    exec { 'jenk-slave':
        command => "java -jar swarm.jar",
        user    => $username,
        cwd     => "/home/$username",
        path    => $defpath,
        require => Exec['fetch-swarmjar']
    }
}

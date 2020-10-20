package nl.vpro.poms.followchanges;

import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import picocli.CommandLine;
import picocli.CommandLine.Command;
import picocli.CommandLine.Option;

import java.io.*;
import java.time.Duration;
import java.time.Instant;

import nl.vpro.api.client.frontend.NpoApiClients;
import nl.vpro.api.client.utils.NpoApiMediaUtil;
import nl.vpro.domain.api.*;
import nl.vpro.util.CountedIterator;
import nl.vpro.util.Env;
import nl.vpro.util.picocli.Picocli;

import static java.nio.charset.StandardCharsets.UTF_8;

/**
 * @author Michiel Meeuwissen
 */
@SuppressWarnings({"FieldMayBeFinal", "InfiniteLoopStatement", "BusyWait"})
@Slf4j
@Command(name = "followchange", mixinStandardHelpOptions = true, version = "1.0",
         description = "Follows the media changes feed of the NPO API")
public class Main implements Runnable {

    @Option(names = {"-e", "--env"}, converter = Picocli.EnvConverter.class)
    private Env env = Env.PROD;

    @Option(names = {"-p", "--profile"})
    private String profile = null;

    @Option(names = {"-s", "--since"}, converter = Picocli.InstantConverter.class)
    private Instant since = Instant.now();

    @Option(names = {"--showtails"})
    private boolean showTails = false;

    @Option(names = {"--sleep"}, converter = Picocli.DurationConverter.class)
    private Duration sleep = Duration.ofMillis(1000);

    @Option(names = {"-t", "--tails"})
    private Tail tail = Tail.IF_EMPTY;

    @SneakyThrows
    public void run() {
        NpoApiClients clients = NpoApiClients
            .configured(env)
            .build();

        NpoApiMediaUtil mediaUtil = NpoApiMediaUtil.builder()
            .clients(clients)
            .build();
        Instant start = since;
        String mid = null;
        int call = 0;
        while(true) {

            try (CountedIterator<MediaChange> changes = mediaUtil.changes(profile, false, start, mid, Order.ASC, null, Deletes.ID_ONLY, tail)) {
                while (changes.hasNext()) {
                    MediaChange change = changes.next();
                    if ((! change.isTail()) || showTails) {
                        log.info(start + ":" + call + ":" + change);
                    }
                    start = change.getPublishDate();
                    mid = change.getMid();
                }
            } catch (Exception e) {
                log.info(e.getMessage());
            }
            call++;
            Thread.sleep(sleep.toMillis());
        }
    }

    public static void main(String[] argv) {
        // output utf-8 always, why would you want it differently.
        System.setOut(new PrintStream(new FileOutputStream(FileDescriptor.out), true, UTF_8));
        System.exit(new CommandLine(new Main()).execute(argv));
    }
}
